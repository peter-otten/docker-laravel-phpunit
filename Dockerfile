FROM php:7.2-fpm-alpine
MAINTAINER Peter Otten <peterotten128@hotmai.com>

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk --update add git \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql mcrypt tokenizer xml
RUN pecl channel-update pecl.php.net && pecl install memcached && docker-php-ext-enable memcached

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /app
WORKDIR /app