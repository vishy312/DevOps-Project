FROM jenkins/jenkins:alpine
LABEL maintainer="Vishal Pal"

USER root
RUN apt-get -qqy update && apt-get -qqy install sudo
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
RUN tar -xvzf docker-latest.tgz
RUN mv /docker/* /usr/bin/

USER jenkins
RUN jenkins-plugin-cli --plugins junit git git-client ssh-slaves greenballs chucknorris ws-cleanup