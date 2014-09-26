require_relative '../util'
AwsUtil.config

swf = AWS.swf

DOMAIN = 'RawSwf2'

# print all domains
#swf.domains.each {|d| puts d.name}

domain = swf.domains[DOMAIN]
unless domain.exists?
  puts "creating"
  domain = swf.domains.create(DOMAIN, 2)
  puts "created"
end

if false
  # register an workflow type with the version id '1'
  workflow_type = domain.workflow_types.create('my-long-processes', '1',
    :default_task_list => 'my-task-list',
    :default_child_policy => :request_cancel,
    :default_task_start_to_close_timeout => 5,
    :default_execution_start_to_close_timeout => 20)

  # register an activity type, with the version id '1'
  activity_type = domain.activity_types.create('do-something', '1',
    :default_task_list => 'my-task-list',
    :default_task_heartbeat_timeout => 5,
    :default_task_schedule_to_start_timeout => 5,
    :default_task_schedule_to_close_timeout => 5,
    :default_task_start_to_close_timeout => 5)
end

workflow_type = nil
domain.workflow_types.each do |wf|
  if wf.name == 'my-long-processes'
    workflow_type = wf
  end
end

puts 'starting'
workflow_execution = workflow_type.start_execution :input => 'robs input'
puts 'started'

puts 'wf id: ', workflow_execution.workflow_id #=> "5abbdd75-70c7-4af3-a324-742cd29267c2"
puts 'run id: ', workflow_execution.run_id #=> "325a8c34-d133-479e-9ecf-5a61286d165f"
