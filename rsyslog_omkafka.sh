#!/bin/bash

set -exu

echo "Building rsyslog with omkafka"

sudo apt-get update

sudo add-apt-repository -y ppa:adiscon/v8-stable

sudo apt-get update

sudo apt-get install -y software-properties-common build-essential pkg-config libestr-dev libfastjson-dev zlib1g-dev uuid-dev libgcrypt20-dev liblogging-stdlog-dev libhiredis-dev libdbi-dev libmysqlclient-dev postgresql-client libpq-dev libnet-dev librdkafka-dev libgrok-dev libgrok1 libgrok-dev libpcre3-dev libtokyocabinet-dev libglib2.0-dev libmongo-client-dev autoconf automake shtool autogen libtool shtool libtool pkg-config flex byacc python-docutils

cd

git clone https://github.com/rsyslog/rsyslog.git

cd rsyslog

sudo autoreconf -vfi
sudo autoconf
./configure --prefix=/usr --enable-omkafka
sudo automake
sudo make
find . -name "*kafka*"
