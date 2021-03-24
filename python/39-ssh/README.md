## Sample Usage

### shell command
```
docker run -d -p 10022:22 -v $(pwd):/root --name python-39-ssh terenceccwu/python:39-ssh
```

### docker-compose.yml
```
version: "3.3"
services:
  app:
    image: terenceccwu/python:39-ssh
    ports:
      - "10022:22"
    volumes:
      - ./enterprise:/root/enterprise
    environment:
      - SSH_ROOT_PASSWORD=pw
    depends_on:
      - db
  db:
    image: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: password
volumes:
  db-data:
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
