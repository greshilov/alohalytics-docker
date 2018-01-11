# Start with ubuntu 17.10

FROM ubuntu:17.10

MAINTAINER greshilov slavik greshilov@maps.me

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get dist-upgrade -y

# Installing packages
RUN apt-get install -y \
  bash \
  git \
  openssl \
  build-essential \
  software-properties-common \
  cmake \
  zlib1g-dev \
  libfcgi-dev \
  spawn-fcgi \
  nginx \
  logrotate \
  --no-install-recommends

RUN mkdir -p /aloha/run
RUN git clone https://github.com/biodranik/Alohalytics /aloha/src
RUN cmake -B/aloha/bin -H/aloha/src
RUN make -C /aloha/bin fcgi_server

CMD ["/bin/bash", "/conf/run.sh"]
