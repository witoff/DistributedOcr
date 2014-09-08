require 'aws-sdk'
require_relative 'util'

module OCR

  class Ocr < Base

    def initialize bucket
      # Collect Config tokens.  Reuse bash so can still be sourced
      @bucket = bucket
      log "initializing with bucket:", @bucket
    end

    def getObjectKeys
      # public URL @ objects[0].public_url
      AWS.s3.buckets[@bucket].objects.collect{|o| o.key }
    end

    def getPdfImageKeys
      pdf_keys = self.getObjectKeys.select{|k| k.end_with? 'tiff.pdf' }
    end

    SQS_QUEUE_NAME = "ocr-pipeline"
    SQS_EMPTY_RETRIES = 5

    def clearQueue
      queue = AWS::SQS.new.queues.named SQS_QUEUE_NAME
      while m = queue.receive_message(wait_time_seconds:1) do
        puts "deleting #{m.body}"
        m.delete
      end
      puts "all messages deleted"
    end

    def listQueue
      queue = AWS::SQS.new.queues.named SQS_QUEUE_NAME
      log "items currently in source queue #{queue.approximate_number_of_messages} "
    end

    def loadQueue

      # Create & Configure Queue
      log "creating queue..."
      queue = AWS::SQS.new.queues.create SQS_QUEUE_NAME
      queue.delay_seconds = 0
      queue.visibility_timeout = 60*5
      queue.message_retention_period = 60*60*24*2
      queue.wait_time_seconds = 10 # set to 0 for short polling
      log "queue created and configured"

      getPdfImageKeys.each do | filename |
        queue.send_message({bucket:@bucket,key:filename}.to_json)
      end

      listQueue
      nil
    end

    def spawnWorkers
      log "spawning"
      #image = AWS.ec2.images[]
      image = AWS.ec2.instances.create(
        image_id:'ami-864d84ee',
        count:3,
        key_name:'aws-east',
        user_data:File.read('container_ocr/userdata.txt'),
        instance_type:'m3.large'
      )
    end
  end
end
