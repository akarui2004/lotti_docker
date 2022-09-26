FROM debian:buster-slim

LABEL maintainer="Minh Doan <minhdpc@gmail.com>"

## Install PHP repository to debian
RUN apt-get update \
    && apt install -y lsb-release ca-certificates zip unzip apt-utils apt-transport-https software-properties-common gnupg2 wget openssl bash curl cron nano

## Add sury debian PPA repository
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

# PHP version
ARG PHP_VERSION

## Update the system again. Install the php8.1 and nginx
RUN apt-get update \
    && apt install -y php${PHP_VERSION} nginx cron

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
# COPY ./php/www.conf /usr/local/etc/php-fpm.d/

# Install composer
ARG COMPOSER_INSTALL=${COMPOSER_INSTALL}
RUN if [ ${COMPOSER_INSTALL} = true ]; then \
    cd /opt \
    && curl -sS https://getcomposer.org/installer | php \
    && ln -s /opt/composer.phar /usr/local/bin/composer \
    && echo 'export PATH=~/.config/composer/vendor/bin:$PATH  #This will load all the bin in the composer' >> ~/.bashrc \
;fi

# Install composer laravel vapor
ARG COMPOSER_LARAVEL_VAPOR=${COMPOSER_LARAVEL_VAPOR}
RUN if [ ${COMPOSER_LARAVEL_VAPOR} = true ]; then \
    /usr/local/bin/composer global require laravel/vapor-cli --update-with-dependencies \
;fi

# NVM arg and env
ARG NVM_INSTALL=${NVM_INSTALL}
ARG YARN_INSTALL=${YARN_INSTALL}
ARG NODE_VERSION=node
ENV NODE_VERSION ${NODE_VERSION}
ENV NVM_DIR $HOME/.nvm
ARG INSTALL_NODE=${INSTALL_NODE}

# Install NVM
RUN if [ ${NVM_INSTALL} = true ]; then \
    mkdir -p $NVM_DIR \
    && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && nvm alias ${NODE_VERSION} \
;fi

# Wouldn't execute when added to the RUN statement in the above block
# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
    echo 'alias node=nodejs' >> ~/.bashrc \
;fi

RUN if [ ${YARN_INSTALL} = true ]; then \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt install -y yarn \
;fi

## START: Nginx ##
COPY ./nginx/conf/nginx.conf /etc/nginx/
ADD ./nginx/default/index.php /var/www/html
## END: Nginx ##

## START: Cron ##
COPY ./cron/crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
# RUN touch /var/log/cron.log
## END: Cron ##

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Configure locale.
ARG LOCALE=POSIX
ENV LC_ALL ${LOCALE}

# Setting workdir
ARG WORK_DIR
ENV APP_WORKDIR ${WORK_DIR}

# Workdir when access to the container
WORKDIR ${APP_WORKDIR}

# Group and Permission for folder
ARG ADD_GROUP=${ADD_GROUP}

ARG GROUP_ID=${GROUP_ID}
ENV GROUPID ${GROUP_ID}

ARG GROUP_NAME=${GROUP_NAME}
ENV GROUPNAME ${GROUP_NAME}

ARG USER_NAME=${USER_NAME}
ENV USERNAME ${USER_NAME}

RUN if [ ${ADD_GROUP} = true ]; then \
    groupadd -g $GROUPID $GROUPNAME \
    && useradd -g $GROUPID $USERNAME \
;fi

# Add NVM binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

# Configure non-root user.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

# Policy
RUN echo "exit 0" > /usr/sbin/policy-rc.d

# nginx
ARG PHP_VERSION
ENV PHP_VERSION ${PHP_VERSION}
CMD service php${PHP_VERSION}-fpm start && nginx -g "daemon off;" & cron -f

EXPOSE 80 443