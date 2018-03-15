# https://hub.docker.com/r/phusion/passenger-ruby23/
FROM phusion/passenger-ruby23:0.9.29 AS builder

ADD . /src
WORKDIR /src

# add the authorized host key for github (avoids "Host key verification failed")
RUN mkdir -p ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

ARG host
ARG port
ENV PRIVATE_KEY /root/.ssh/id_rsa
RUN curl -o $PRIVATE_KEY http://$host:port/v1/secrets/file/id_rsa \
  && chmod 0600 $PRIVATE_KEY \
  && ssh -T git@github.com \
  bundle install --path vendor/bundle \
  && rm $PRIVATE_KEY

FROM phusion/passenger-ruby23:0.9.29 AS runtime
COPY --from=builder /src /app
WORKDIR /app
CMD ["bundle exec rails s"]
