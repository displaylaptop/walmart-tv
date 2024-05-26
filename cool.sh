#!/bin/bash

# Install dependencies
apt-get update
apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev

# Download Nginx source code
NGINX_VERSION="1.26.0"  # Change this to the desired Nginx version
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -zxvf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}

# Download RTMP module
RTMP_MODULE_VERSION="1.2.2"  # Change this to the desired RTMP module version
wget https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_VERSION}.tar.gz
tar -zxvf v${RTMP_MODULE_VERSION}.tar.gz

# Configure Nginx with RTMP module
./configure --with-http_ssl_module --add-module=./nginx-rtmp-module-${RTMP_MODULE_VERSION}

# Compile and install Nginx
make
make install

# Cleanup
cd ..
rm -rf nginx-${NGINX_VERSION} nginx-${NGINX_VERSION}.tar.gz nginx-rtmp-module-${RTMP_MODULE_VERSION} v${RTMP_MODULE_VERSION}.tar.gz
