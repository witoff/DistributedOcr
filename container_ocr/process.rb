#! /usr/bin/ruby

puts "\nRunning OCR:"
system "ruby pdfocr.rb -i /opt/ocr/data/#{ARGV[0]} -o #{ARGV[0]}"

puts "\nMoving File:"
system "scp -o StrictHostKeyChecking=no -i /.ssh/gc-datascience #{ARGV[0]} witoff@192.168.1.234:~"

# N.B. Can move files more elegantly through boot2docker with
#      volume mounting via extra docker container here:
#      https://github.com/boot2docker/boot2docker
