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
  --no-install-recommends

RUN mkdir -p /aloha/run
RUN git clone https://github.com/biodranik/Alohalytics /aloha/src
RUN cmake -B/aloha/bin -H/aloha/src
RUN make -C /aloha/bin fcgi_server

RUN echo 'yes | cp -rf /conf/nginx.conf /etc/nginx/nginx.conf \n\
spawn-fcgi -a 127.0.0.1 -p 8888 -P /aloha/run/aloha.pid -- /aloha/bin/server/fcgi_server /data /monitoring \n\
nginx \n\
while :; do \n\
  sleep 300 \n\
done' > /etc/run.sh

CMD ["/bin/bash", "/etc/run.sh"]
