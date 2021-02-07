FROM php:7.4.13-fpm

RUN apt-get update -y && apt-get upgrade -fy && apt-get install -y curl
RUN apt-get install -fy imagemagick librsvg2-bin poppler-utils ghostscript libgs-dev lua5.3 python python-pip
RUN pip install pygments

# Install composer
RUN mkdir /opt/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/opt/composer

RUN printf "\n \n" | pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

RUN docker-php-ext-install opcache \
    && docker-php-ext-install sockets

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY memory.ini /usr/local/etc/php/conf.d/memory.ini
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY pm.conf /usr/local/etc/php-fpm.d/pm.conf

COPY sitemaps.sh /sitemaps.sh
COPY boot.sh /boot.sh

RUN chmod +x /sitemaps.sh

CMD "/boot.sh"
