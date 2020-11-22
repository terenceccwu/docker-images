FROM ruby:2.7

RUN gem install rails

RUN apt update && apt install openssh-server sudo -y
RUN useradd -rm -d /home/user -s /bin/bash -g root -G sudo -u 1000 user
RUN echo 'user:pw' | chpasswd
RUN service ssh start

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
