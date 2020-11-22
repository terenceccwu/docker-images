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
      - rails-src:/home/user/app
    ports:
      - "10022:22"
    depends_on:
      - db
  db:
    image: postgres
    volumes:
      - ./tmp/db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
volumes:
  rails-src:
```

### vscode config

~/.ssh/config
```
Host <homename>
    HostName <homename>
    User user
    Port 10022
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```
