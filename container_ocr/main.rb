require 'aws-sdk'
require_relative '../util'


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

  # pass these two args into docker container
  file_path = nil

  File.open(key, 'wb') do |file|
    object.read do |chunk|
       file.write(chunk)
       path = File.expand_path(File.dirname(__FILE__))
    end
    # save the pilepath
    file_path = File.expand_path(file)
  end

  system "ruby /opt/ocr/pdfocr/pdfocr.rb -i \"#{file_path}\" -o \"#{file_path}.processed.pdf\""

  # upload to s3
  puts "uploading"
  output = bucket.objects["processed/#{key}"]
  output.write(:file => "#{file_path}.processed.pdf")
  puts "done"

  message.delete
end
