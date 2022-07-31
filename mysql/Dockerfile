ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

LABEL maintainer="Minh Doan <minhdpc@gmail.com>"

# Set timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && chown -R mysql:root /var/lib/mysql/

# MySQL config file
COPY my.cnf /etc/mysql/conf.d/my.cnf

# Set the permission for the config file
RUN chmod 0444 /etc/mysql/conf.d/my.cnf

CMD ["mysqld"]

EXPOSE 3306