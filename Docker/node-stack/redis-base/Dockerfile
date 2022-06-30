FROM ubuntu:20.04
LABEL maintainer="Vishal Pal"

RUN apt-get -yqq update apt-get -yqq install software-properties-common\
python-software-properties
RUN add-apt-repository ppa:chris-lea/redis-server
RUN apt-get -yqq update && apt-get -yqq install redis-server redis-tools

VOLUME [ "/var/lib/redis", "/var/log/redis" ]

EXPOSE 6379
CMD []