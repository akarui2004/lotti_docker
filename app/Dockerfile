FROM debian:buster

LABEL maintainer="Minh Doan <minhdpc@gmail.com>"

## Install PHP repository to debian
RUN apt-get update \
    && apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 wget openssl bash curl

## Add sury debian PPA repository
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

# PHP version
ARG PHP_VERSION

## Update the system again. Install the php8.1 and nginx
RUN apt-get update \
    && apt install -y php${PHP_VERSION} nginx

# Install needed extension for php
RUN apt-get -y install php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-exif

# Copy the php config
COPY ./php/x.pool.conf /usr/local/etc/php-fpm.d/

# Install composer
ARG COMPOSER_INSTALL=${COMPOSER_INSTALL}
RUN if [ ${COMPOSER_INSTALL} = true ]; then \
    cd /opt \
    && curl -sS https://getcomposer.org/installer | php \
    && ln -s /opt/composer.phar /usr/local/bin/composer \
;fi

## START: Nginx ##
COPY ./nginx/conf/nginx.conf /etc/nginx/
ADD ./nginx/startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
## END: Nginx ##

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Configure locale.
ARG LOCALE=POSIX
ENV LC_ALL ${LOCALE}

# Setting workdir
ARG WORK_DIR
WORKDIR /var/www

CMD ["php-fpm", "/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443