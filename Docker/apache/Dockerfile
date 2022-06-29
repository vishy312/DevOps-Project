FROM ubuntu:20.04
LABEL maintainer="Vishal Pal"

RUN apt-get -yqq update && apt-get -yqq install apache2

VOLUME [ "/var/www/html" ]
WORKDIR /var/www/html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p ${APACHE_LOCK_DIR} ${APACHE_LOG_DIR} ${APACHE_RUN_DIR}

#COPY index.html .

EXPOSE 80

ENTRYPOINT ['/usr/bin/apache2ctl']
CMD ['-D', "FOREGROUND"]