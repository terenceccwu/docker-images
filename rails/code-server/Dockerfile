FROM ruby:2.7

RUN gem install rails

# install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
