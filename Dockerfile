FROM php:7.1.30-fpm-alpine3.9
MAINTAINER Lework <lework@yeah.net>

ARG WORKSPACE=/src

ENV WORKSPACE=${WORKSPACE} \
    TIMEZONE=Asia/Shanghai
	
	
RUN apk --update -t --no-cache add tzdata \
    && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    \
    && apk add --no-cache --virtual .build-deps \
    gcc \
    make \
    autoconf \
    sqlite-dev \
    libmemcached \
    libcurl \
    && apk add --no-cache augeas-dev \
    musl-dev \
    linux-headers \
    libmcrypt-dev \
    libpng-dev \
    icu-dev \
    libpq \
    libressl-dev \
    libxslt-dev \
    libffi-dev \
    freetype-dev \
    libmemcached-dev \
    libjpeg-turbo-dev \
    && docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install iconv pdo_mysql pdo_sqlite mysqli gd mbstring bcmath exif intl xsl json soap dom zip opcache pcntl \
    && pecl install xdebug-2.6.0 \
    && pecl install apcu \
    && pecl install igbinary \
    && pecl install memcached \
    && pecl install mongodb \
    && pecl install redis \
    \
    && docker-php-source delete \
    && apk del --no-network .build-deps \
    && rm -rf /tmp/pear/* /var/cache/apk/* ~/.pearrc \
    && docker-php-ext-enable apcu redis xdebug mongodb memcached \
    \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#; max_input_vars = 1000#max_input_vars = 2000#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#post_max_size = 8M#post_max_size = 200M#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 200M#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#;pm.status_path = /status#pm.status_path = /fpm-status#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;ping.path = /ping#ping.path = /fpm-ping#g' /usr/local/etc/php-fpm.d/www.conf \
    \
    && mkdir -p ${WORKSPACE} \
    \
    && apk add nginx curl \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && echo '<?php phpinfo(); ?>' > ${WORKSPACE}/index.php

COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-run.sh /docker-run.sh

RUN chmod +x /docker-run.sh

EXPOSE 80

VOLUME ${WORKSPACE}

WORKDIR ${WORKSPACE}

ENTRYPOINT ["/docker-run.sh"]
