require 'aws-sdk'

# load messages into ocr-pipeline.  Run until
count = 0
while 1 do
  message = queue.receive_message
  if message
    puts "received message: #{message.body}"
    content = JSON.parse(message.body)

    bucket_name = content[:bucket]
    key = content[:key]

    bucket = AWS.s3.buckets[bucket_name]
    object = bucket.objects[key]

    File.open(key, 'wb') do |file|
      obj.read do |chunk|
         file.write(chunk)
      end
    end

    message.delete
  else
    # run until 3
    puts "no message"
    count += 1
    if count > SQS_EMPTY_RETRIES
      return
    end
  end
end # while
