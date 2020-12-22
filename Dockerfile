FROM alpine:3.12.1 as config-alpine

RUN apk add --no-cache tzdata

RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

FROM alpine:3.12.1 as src-fluentd

RUN apk add --no-cache \
 build-base \
 git \
 ruby \
 ruby-dev

RUN git clone --branch v1.11.5 --depth 1 https://github.com/fluent/fluentd.git

WORKDIR /fluentd

RUN gem install bundler \
&& bundle install \
&& bundle exec rake build \
&& gem install pkg/fluentd-*.gem etc bigdecimal json webrick

FROM alpine:3.12.1

COPY --from=config-alpine /etc/localtime /etc/localtime
COPY --from=config-alpine /etc/timezone  /etc/timezone

EXPOSE 24443

RUN apk add --no-cache ruby 

COPY --from=src-fluentd /usr/lib/ruby/gems /usr/lib/ruby/gems
COPY --from=src-fluentd /usr/bin/fluentd /usr/bin/fluentd

RUN fluentd --setup /etc/fluentd \
 && mkdir -p /var/logs/pods

ENTRYPOINT ["/usr/bin/fluentd", "--config"]
CMD ["/etc/fluentd/fluent.conf", "-vv"]
