FROM php:7.4

ENV PHP_EXT_DOWNLOAD_PATH /tmp/
ENV PHP_EXT_PATH /usr/src/php/ext/

ENV PHP_REDIS_DOWNLOAD_PACKAGE phpredis
ENV PHP_REDIS_DOWNLOAD_TAR phpredis-5.2.2
ENV PHP_REDIS_EXT_DIR phpredis

ENV SWOOLE_DOWNLOAD_PACKAGE swoole
ENV SWOOLE_EXT_DIR swoole
ENV SWOOLE_DOWNLOAD_TAR swoole-src-4.5.2

WORKDIR ${PHP_EXT_DOWNLOAD_PATH}

RUN docker-php-source extract 

RUN curl -L -o ${PHP_EXT_DOWNLOAD_PATH}${PHP_REDIS_DOWNLOAD_PACKAGE} https://github.com/phpredis/phpredis/archive/5.2.2.tar.gz\
&& tar -xvf ${PHP_EXT_DOWNLOAD_PATH}${PHP_REDIS_DOWNLOAD_PACKAGE}\
&& mv ${PHP_EXT_DOWNLOAD_PATH}${PHP_REDIS_DOWNLOAD_TAR} ${PHP_EXT_PATH}${PHP_REDIS_EXT_DIR}\
&& docker-php-ext-install ${PHP_REDIS_EXT_DIR}

RUN curl -L -o ${PHP_EXT_DOWNLOAD_PATH}${SWOOLE_DOWNLOAD_PACKAGE} https://github.com/swoole/swoole-src/archive/v4.5.2.tar.gz\
&& tar -xvf ${PHP_EXT_DOWNLOAD_PATH}${SWOOLE_DOWNLOAD_PACKAGE}\
&& mv ${PHP_EXT_DOWNLOAD_PATH}${SWOOLE_DOWNLOAD_TAR} ${PHP_EXT_PATH}${SWOOLE_EXT_DIR}\
&& docker-php-ext-install ${SWOOLE_EXT_DIR}

RUN apt-get update && apt-get install -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev \
&& docker-php-ext-configure gd --with-freetype --with-jpeg\
&& docker-php-ext-install -j$(nproc) gd

RUN apt-get update\
&& apt-get install -y libbz2-dev\
&& rm -r /var/lib/apt/lists/*\
&& docker-php-ext-install -j$(nproc) bz2

RUN apt-get update\ 
&& apt-get install -y libgmp-dev\ 
&& rm -r /var/lib/apt/lists/*\
&& docker-php-ext-install -j$(nproc) gmp

RUN apt-get update \
&& apt-get install -y libxml2-dev libtidy-dev libxslt1-dev \ 
&& rm -r /var/lib/apt/lists/* \ 
&& docker-php-ext-install -j$(nproc) soap xmlrpc tidy xsl

RUN apt-get update \
&& apt-get install -y libzip-dev \
&& rm -r /var/lib/apt/lists/* \ 
&& docker-php-ext-install -j$(nproc) zip

RUN apt-get update \
&& apt-get install -y libsnmp-dev \
&& rm -r /var/lib/apt/lists/* \
&& docker-php-ext-install -j$(nproc) snmp

RUN apt-get update \
&& apt-get install -y libpq-dev \
&& rm -r /var/lib/apt/lists/* \
&& docker-php-ext-install -j$(nproc) pgsql pdo_pgsql

RUN apt-get update\ 
&& apt-get install -y firebird-dev\
&& rm -r /var/lib/apt/lists/*\
&& docker-php-ext-install -j$(nproc) pdo_firebird

RUN apt-get update\ 
&& apt-get install -y freetds-dev\ 
&& rm -r /var/lib/apt/lists/*\ 
&& docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu\
&& docker-php-ext-install -j$(nproc) pdo_dblib

RUN apt-get update\
&& apt-get install -y --no-install-recommends libldap2-dev\
&& rm -r /var/lib/apt/lists/*\
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu\
&& docker-php-ext-install -j$(nproc) ldap

RUN apt-get update\ 
&& apt-get install -y --no-install-recommends libc-client-dev libkrb5-dev\
&& rm -r /var/lib/apt/lists/*\
&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl\
&& docker-php-ext-install -j$(nproc) imap

RUN apt-get update\ 
&& apt-get install -y libicu-dev\
&& rm -r /var/lib/apt/lists/*\ 
&& docker-php-ext-install -j$(nproc) intl

RUN apt-get update\
&& apt-get install -y zlib1g-dev libmemcached-dev\
&& rm -r /var/lib/apt/lists/*\ 
&& pecl install memcached\
&& docker-php-ext-enable memcached

RUN docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache

RUN docker-php-source delete

CMD php -v && php -m
