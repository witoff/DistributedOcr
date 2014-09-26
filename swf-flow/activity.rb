require_relative 'utils'


class HelloWorldActivity
  extend AWS::Flow::Activities

  activity :say_hello do
    {
      version: HelloWorldUtils::ACTIVITY_VERSION,
      default_task_list: HelloWorldUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      default_task_schedule_to_start_timeout: 5,
      default_task_start_to_close_timeout: 5
    }
  end

  def say_hello(name)
    puts "\nhello, #{name}!"
  end

  activity :say_bye do
    {
      version: HelloWorldUtils::ACTIVITY_VERSION,
      default_task_list: HelloWorldUtils::ACTIVITY_TASKLIST,
      # timeout values are in seconds.
      default_task_schedule_to_start_timeout: 5,
      default_task_start_to_close_timeout: 5
    }
  end

  def say_bye(name)
    puts "\nbye, #{name}!"
  end

end

HelloWorldUtils.new.activity_worker(HelloWorldActivity).start if $0 == __FILE__
