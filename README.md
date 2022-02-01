# Docker Images with SSH Service

## Why?

Having a consistent development environment reduces headaches. Developing on docker images will be one of the best choices. However, remote container plugins are painfully slow, no matter in VS Code or JetBrains IDEs. Remote SSH variants are usually much performant.

This README documents the instructions to create images with ssh service exposed for development purpose. Sample images are also included in this repo.

## How to Create New Image with ssh service?
1. Create a new folder with 
1. Copy sample docker-entrypoint.sh
1. Replace `/usr/local/bin/docker-entrypoint.sh` with entrypoint file of original image. (`"$@"` means redirect all command line arguments to this script. use `exec "$@"` if no parent entrypoint is available.)
1. Copy sample Dockerfile
1. Replace CMD with original CMD `["apache2-foreground"]` (must be present, otherwise it will be empty)
1. Docker build with this format (`-ssh` suffix): `docker build -t terenceccwu/wordpress:5.9.0-apache-ssh .`
1. When creating image, please set `SSH_ROOT_PASSWORD` ENV variable (refer to sample docker-compose or shell command)

## Sample docker-entrypoint.sh

```bash
#!/usr/bin/env bash

set -ex

FILE_INITIALIZED=/etc/docker-initialized

initial_setup() {
    if [ -z "$SSH_ROOT_PASSWORD" ]; then
        echo >&2 "error: SSH_ROOT_PASSWORD is not set"
        exit 1
    fi

    echo "root:$SSH_ROOT_PASSWORD" | chpasswd


    touch "$FILE_INITIALIZED"
}

if test ! -f "$FILE_INITIALIZED"; then
    initial_setup # setup root password
fi

/usr/sbin/sshd # start ssh server, default daemon mode

<replace me. sample: /usr/local/bin/docker-entrypoint.sh> "$@"
```

## Sample Dockerfile

```docker
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

CMD ["<replace me. sample: apache2-foreground>"]
```

## How to Use?

Create container either with shell command or docker-compose. Then, connect to the container with vs code.

### shell command
```
docker run -d -p 10022:22 -v $(pwd):/var/www/html --name wordpress terenceccwu/wordpress:5.9.0-apache-ssh
```

### docker-compose.yml
```
version: "3.3"
services:
  wordpress:
    image: terenceccwu/wordpress:5.9.0-apache-ssh
    ports:
      - "10034:80"
      - "10035:22"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: wp_1
      SSH_ROOT_PASSWORD: pw
    volumes:
      - wordpress-data:/var/www/html
  mysql:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wp_1
      MYSQL_USER: user
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - mysql-data:/var/lib/mysql
volumes:
  wordpress-data:
  mysql-data:
```

### vscode config

~/.ssh/config
```
Host <hostname>
    HostName <hostname>
    User root
    Port 10022
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```
