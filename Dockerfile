FROM php:7.3.33-fpm-alpine3.13
MAINTAINER Lework <lework@yeah.net>

ARG WORKSPACE=/src

ENV WORKSPACE=${WORKSPACE} \
    TIMEZONE=Asia/Shanghai

	
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --update -t --no-cache add tzdata \
    && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    \
    && apk add --no-cache --virtual .build-deps \
    build-base \
    gcc \
    make \
    autoconf \
    musl-dev \
    \
    && apk add --no-cache \
    libpq \
    libtool \
    libcurl \
    freetds \
    libzip-dev \
    libffi-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    libressl-dev \
    libmemcached \
    linux-headers \
    libmcrypt-dev \
    libmemcached-dev \
    libjpeg-turbo-dev \
    gmp-dev \
    bzip2-dev \
    sqlite-dev \
    augeas-dev \
    gettext-dev \
    freetds-dev \
    freetype-dev \
    postgresql-dev \
    imagemagick \
    imagemagick-dev \
    \
    && pecl install xdebug \
    && pecl install apcu \
    && pecl install igbinary \
    && pecl install memcached \
    && pecl install mongodb \
    && pecl install redis \
    && pecl install mcrypt \
    && pecl install imagick \
    && pecl install msgpack \
    \
    && docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \

    && docker-php-ext-install pdo_mysql mysqli gd bcmath exif intl xsl soap zip opcache pcntl \
	                      pdo_dblib gettext calendar shmop sockets wddx pdo_pgsql gmp bz2 xmlrpc \
    && docker-php-ext-enable apcu redis xdebug mongodb memcached imagick mcrypt \
    \
    && docker-php-source delete \
    && apk del --no-network .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* ~/.pearrc \
    \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && mkdir -p /usr/local/log/ \
    && sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#; max_input_vars = 1000#max_input_vars = 2000#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#post_max_size = 8M#post_max_size = 200M#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 200M#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#;error_log = php_errors.log#error_log = php_errors.log#g' "$PHP_INI_DIR/php.ini" \
    && sed -i 's#;pid = run/php-fpm.pid#pid = run/php-fpm.pid#g' /usr/local/etc/php-fpm.conf \
    && sed -i 's#;error_log = log/php-fpm.log#error_log = log/php-fpm.log#g' /usr/local/etc/php-fpm.conf \
    && sed -i 's#;ping.path = /ping#ping.path = /fpm-ping#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;pm.status_path = /status#pm.status_path = /fpm-status#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;catch_workers_output = yes#catch_workers_output = yes#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;access.log = log/$pool.access.log#access.log = log/$pool.access.log#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;slowlog = log/$pool.log.slow#slowlog = log/$pool.log.slow#g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's#;request_slowlog_timeout = 0#request_slowlog_timeout = 2#g' /usr/local/etc/php-fpm.d/www.conf \
    \
    && mkdir -p ${WORKSPACE}
    
RUn apk add nginx curl \
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
