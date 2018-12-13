FROM php:7.1.24-fpm-alpine3.8
MAINTAINER Lework <lework@yeah.net>

ARG WORKSPACE=/Microservices

RUN apk --update -t --no-cache add tzdata && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk add --no-cache --virtual .build-deps \
    gcc \
    make \
    autoconf \
    sqlite-dev \
    libressl-dev \
    libmemcached \
    libcurl && \
    apk add --no-cache augeas-dev \
    musl-dev \
    linux-headers \
    libmcrypt-dev \
    libpng-dev \
    icu-dev \
    libpq \
    libxslt-dev \
    libffi-dev \
    freetype-dev \
    libmemcached-dev \
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
    apk del .build-deps  && \
    rm -rf /tmp/pear/* /var/cache/apk/* ~/.pearrc && \
    docker-php-ext-enable apcu redis xdebug mongodb memcached && \
    mkdir ${WORKSPACE} && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#g' "$PHP_INI_DIR/php.ini"
    
VOLUME ${WORKSPACE}
