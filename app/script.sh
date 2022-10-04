#!/bin/sh

service php${PHP_VERSION}-fpm start
nginx -g "daemon off;"
cron -f