# OCR Dockerfilie

# FROM ubuntu:14.04
FROM debian:jessie

RUN apt-get update
RUN apt-get install -y \
  git \
  vim \
  python \
  curl \
  ruby \
  vim
RUN apt-get install -y pdftk \
  poppler-utils \
  tesseract-ocr \
  exactimage \
  mercurial

# Setup Disk
RUN mkdir /opt/ocr/

##################
# Install pdfocr #
##################

WORKDIR /opt/ocr/
RUN curl -LkSs https://api.github.com/repos/gkovacs/pdfocr/tarball  -o master.tar.gz
RUN tar -xvzf master.tar.gz
RUN rm master.tar.gz
RUN mv gkovacs* pdfocr

##############
# MOVE FILES #
##############

COPY ./data /opt/ocr/data

RUN mkdir /.ssh
COPY ./gc-datascience /.ssh/
RUN chmod 700 /.ssh/*

COPY ./process.rb /opt/ocr/pdfocr/

#######
# RUN #
#######

WORKDIR /opt/ocr/pdfocr/
ENTRYPOINT ["ruby", "process.rb"]

# run with:
#   docker build -t eva .
# interactive tty with:
#   docker run -i -t eva /bin/bash
# run on files with
#   docker run eva <filename>
# drive all with:
#   Dir.foreach('./data') { |f| system "docker run eva_debian " + f if f.include?'NCR' }
