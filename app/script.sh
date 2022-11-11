#!/bin/sh

service php${PHP_VERSION}-fpm start
nginx -g "daemon off;"
cron -f
chown --changes --silent --no-dereference --recursive --from=33:33 1000:1000 ~/.config/composer /var/run/php /var/lib/php/sessions