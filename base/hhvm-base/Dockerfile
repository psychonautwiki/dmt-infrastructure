FROM hhvm/hhvm-proxygen:latest

RUN apt-get update -y && apt-get upgrade -fy && apt-get install -y curl
RUN apt-get install -fy imagemagick php-imagick librsvg2-bin poppler-utils ghostscript libgs-dev lua5.2 python python-pip
RUN pip install pygments

# Install composer
RUN mkdir /opt/composer
RUN curl -sS https://getcomposer.org/installer | hhvm --php -- --install-dir=/opt/composer

WORKDIR /var/www/public
