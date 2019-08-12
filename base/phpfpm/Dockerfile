FROM php:7.3-fpm

RUN apt-get update -y && apt-get upgrade -fy && apt-get install -y curl
RUN apt-get install -fy imagemagick librsvg2-bin poppler-utils ghostscript libgs-dev lua5.2 python python-pip
RUN pip install pygments

# Install composer
RUN mkdir /opt/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/opt/composer

RUN printf "\n \n" | pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

RUN docker-php-ext-install opcache \
    && docker-php-ext-install sockets

COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
