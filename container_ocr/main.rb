require 'aws-sdk'
require '../util'


# configure params
AwsUtil.config

# load messages into ocr-pipeline.  Run until
SQS_QUEUE_NAME = "ocr-pipeline"
queue = AWS::SQS.new.queues.named SQS_QUEUE_NAME

while message = queue.receive_message do
  puts "received message: #{message.body}"
  content = JSON.parse(message.body)

  bucket_name = content['bucket']
  key = content['key']

  puts "bucket: ", bucket_name
  puts "key: ", key

  bucket = AWS.s3.buckets[bucket_name]
  object = bucket.objects[key]

  File.open(key, 'wb') do |file|
    object.read do |chunk|
       file.write(chunk)
    end
  end

  message.delete
end
