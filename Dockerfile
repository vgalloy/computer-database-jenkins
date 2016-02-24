FROM jenkins:1.642.1
 
ENV DEBIAN_FRONTEND noninteractive
# Le script sh ne peut être executer sans les droits root 
USER root

# On installe Docker
RUN curl -sSL https://get.docker.com/ | sh

#On copie les plugins dans le dossier de jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt

#On execute le script de jenkins permettant l'installation des plugins
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

#On set l'adresse du serveur docker
ENV DOCKER_HOST tcp://docker:2375