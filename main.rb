require 'aws-sdk'
require_relative 'start_ocr'
require_relative 'util'

# Configure AWS
AwsUtil.config
AwsUtil.listSqs

#######################
# Load files into SQS #
#######################
BUCKET = 'witoff-ocr'
ocr = OCR::Ocr.new(BUCKET)

puts "\nGetting Keys"
puts ocr.getObjectKeys[1...10]
#ocr.loadSqsp

# Spinup nodes to process each file in SQS
puts "\nStarting OCR"
ocr.clearQueue
ocr.loadQueue

# Finish with printing URLs of each new file
#ocr.spawnWorkers
