FROM hhvm/hhvm-proxygen:latest

RUN apt-get update -y && apt-get install -y curl
RUN apt-get install -fy imagemagick php5-imagick librsvg2-bin poppler-utils ghostscript libgs-dev lua5.2

# Install composer
RUN mkdir /opt/composer
RUN curl -sS https://getcomposer.org/installer | hhvm --php -- --install-dir=/opt/composer

WORKDIR /var/www/public

#/usr/bin/hhvm /opt/composer/composer.phar install
