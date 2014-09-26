require_relative '../util'
AwsUtil.config

swf = AWS.swf

DOMAIN = 'RawSwf2'
domain = swf.domains[DOMAIN]

# poll 'my-task-list' for activities
domain.activity_tasks.poll('my-task-list') do |activity_task|
  puts "activity"
  #puts activity_task.input
  case activity_task.activity_type.name
  when 'do-something'
    #puts "doing"
    #puts activity_task.input
  else
    activity_task.fail! :reason => 'unknown activity task type'
  end
  true
end
