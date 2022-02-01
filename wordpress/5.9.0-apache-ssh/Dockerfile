FROM wordpress:5.9.0-apache

USER root

RUN apt update && apt install openssh-server sudo -y
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# ensure variables passed to docker container are also exposed to ssh sessions
# src: https://github.com/jenkinsci/docker-ssh-agent/blob/master/setup-sshd
RUN env | egrep "^(PATH|HOSTNAME)=" | awk '{print "export " $0}' > /etc/profile.d/docker-env.sh
RUN service ssh start

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["apache2-foreground"]
