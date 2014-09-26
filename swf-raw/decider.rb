require_relative '../util'
AwsUtil.config

swf = AWS.swf

DOMAIN = 'RawSwf2'
domain = swf.domains[DOMAIN]


inputs = ['one', 'two', 'three', 'four']

# poll for decision tasks from 'my-task-list'
domain.decision_tasks.poll('my-task-list') do |task|

  # investigate new events and make decisions
  task.new_events.each do |event|
    case event.event_type
    when 'WorkflowExecutionStarted'
      puts "\nstarted"
      task.schedule_activity_task({name:'do-something', version:"1"}, :input => inputs.pop)
    when 'ActivityTaskCompleted'
      puts "\ncompleted"
      puts "--task: ", task

      puts "--event", event
      puts "--event.event_type", event.event_type
      data = inputs.pop
      if data
        task.schedule_activity_task({name:'do-something', version:"1"}, :input => data)
      else
        task.complete_workflow_execution # :result => event.attributes.result
      end
    end
  end

end # decision task is completed here
