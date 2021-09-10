ARG ALPINE_TAG=3.14.1
FROM alpine:$ALPINE_TAG as config-alpine

RUN apk add --no-cache tzdata

RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

FROM alpine:$ALPINE_TAG as src-fluentd

ARG BRANCH=v0.0.0

RUN apk add --no-cache \
 build-base \
 git \
 ruby \
 ruby-dev

RUN git clone --branch $BRANCH --depth 1 https://github.com/fluent/fluentd.git

WORKDIR /fluentd

RUN gem install bundler \
&& bundle install \
&& bundle exec rake build \
&& gem install pkg/fluentd-*.gem etc bigdecimal json webrick

FROM alpine:$ALPINE_TAG

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
