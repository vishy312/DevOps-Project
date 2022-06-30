FROM ubuntu:20.04
LABEL maintainer="Vishal Pal"

RUN apt-get -yqq update && apt-get -yqq install nodejs npm
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN mkdir -p /var/log/nodeapp

ADD nodeapp /opt/nodeapp/
WORKDIR /opt/nodeapp

RUN npm install

EXPOSE 3000
ENTRYPOINT ["nodejs", "server.js"]
