## Sample Usage

### shell command
```
docker run -d -p 10022:22 -v $(pwd):/home/user -u "$(id -u):$(id -g)" --name rails-ssh terenceccwu/ruby:2.7-rails6.0-ssh
```

### docker-compose.yml
```
version: "3.8"
services:
  rails:
    image: terenceccwu/ruby:2.7-rails6.0-ssh
    volumes:
      - rails-src:/srv
    ports:
      - "10022:22"
    envionment:
      - SSH_ROOT_PASSWORD=pw
    depends_on:
      - db
  db:
    image: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
volumes:
  rails-src:
  db-data:
```

### vscode config

~/.ssh/config
```
Host <homename>
    HostName <homename>
    User root
    Port 10022
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```
