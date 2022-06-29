FROM ubuntu:20.04
LABEL maintainer="Vishal Pal"

RUN apt-get -yqq update apt-get -yqq install wget

VOLUME [ "/var/lib/tomcat8/webapps/" ]
WORKDIR /var/lib/tomcat8/webapps/

ENTRYPOINT [ "wget" ]
CMD ["-?"]