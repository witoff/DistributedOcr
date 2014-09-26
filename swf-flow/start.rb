require_relative 'utils'
require_relative 'workflow'
require_relative 'activity'

HelloWorldUtils.new.workflow_client(HelloWorldWorkflow).start_execution(ARGV.join)
