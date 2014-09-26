require_relative 'utils'
require_relative 'activity'

class HelloWorldWorkflow
  extend AWS::Flow::Workflows

  workflow :hello do
    {
      version: HelloWorldUtils::WF_VERSION,
      task_list: HelloWorldUtils::WF_TASKLIST,
      execution_start_to_close_timeout: 5,
    }
  end

  activity_client(:client) { { from_class: "HelloWorldActivity" } }

  def hello(name)
    puts "\nworkflow on #{name}"
    if name.include? 'hi'
      puts "working on hi"
      client.say_hello(name)
    elsif name.include? 'bye'
      puts "working on bye"
      client.say_bye(name)
    else
      puts 'no further action'
    end
  end
end

HelloWorldUtils.new.workflow_worker(HelloWorldWorkflow).start if $0 == __FILE__
