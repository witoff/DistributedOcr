require 'aws-sdk'

class Base
  def log *args
    args.each do |l|
      puts l
    end
  end
end


class AwsUtil < Base
  def self.config
    key,secret,region = File.read('.aws-config').lines.collect { |x| /=(.*)/.match(x).captures[0][1...-1] }
    AWS.config(access_key_id: key, secret_access_key: secret, region: region)
  end

  def self.listBuckets
    # List all buckets in this account
    AWS.s3.buckets.each { |b| puts b.name }
  end

  def self.listSqs
    sqs = AWS::SQS.new
    puts "you have #{sqs.queues.count} queues"
    puts "they are named: ", sqs.queues.collect(&:url)

  end

  def self.testSqs
    queues = AWS::SQS.new.queues.collect {|q| q}
    q = queues[0]
    q_dead = queues[1]

    # send some messages
    6.times { |n| q.send_message "sending test #{n}" }

    puts "items in source queue #{q.approximate_number_of_messages} "
    puts "items in dead letter queue #{q_dead.approximate_number_of_messages} "

    # this message isn't deleted so it will be pushed into the dead queue
    dead_message = q.receive_message

    while m = q.receive_message do
      puts 'got message ' + m.body
      m.delete
    end
  end

end
