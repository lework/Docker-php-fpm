FROM php:7.1.24-fpm-alpine3.8
MAINTAINER Lework <lework@yeah.net>

ARG WORKSPACE=/Microservices

RUN apk --update -t --no-cache add tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk update && apk upgrade && \
    apk add --no-cache \
    openssh-client \
    libcurl \
    augeas-dev \
    libressl-dev \
    ca-certificates \
    dialog \
    autoconf \
    make \
    gcc \
    musl-dev \
    linux-headers \
    libmcrypt-dev \
    libpng-dev \
    icu-dev \
    libpq \
    libxslt-dev \
    libffi-dev \
    freetype-dev \
    sqlite-dev \
    libmemcached-devel \
    libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install iconv pdo_mysql pdo_sqlite mysqli gd exif intl xsl json soap dom zip opcache && \
    pecl install xdebug-2.6.0 && \
    pecl install apcu && \
    pecl install igbinary && \
    pecl install memcached && \
    pecl install mongodb && \
    pecl install redis && \
    docker-php-source delete && \
    docker-php-ext-enable apcu redis xdebug mongodb memcached && \
    mkdir ${WORKSPACE}
    
VOLUME ${WORKSPACE}
