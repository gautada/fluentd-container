ARG ALPINE_TAG=3.14.2

ARG RUBY_TAG=3.0.2-alpine3.14

FROM alpine:$ALPINE_TAG as config-alpine

RUN apk add --no-cache tzdata

RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

# FROM ruby:$RUBY_TAG as src-fluentd
FROM alpine:$ALPINE_TAG as src-fluentd

ARG BRANCH=v0.0.0

RUN apk add --no-cache build-base git \
 ruby ruby-dev

RUN git clone --branch $BRANCH --depth 1 https://github.com/fluent/fluentd.git

WORKDIR /fluentd

RUN gem install etc bigdecimal bundler json webrick
RUN bundle install
RUN bundle exec rake build
RUN gem install pkg/fluentd-*.gem


FROM alpine:$ALPINE_TAG

# ARG VERSION=v0.0.0

COPY --from=config-alpine /etc/localtime /etc/localtime
COPY --from=config-alpine /etc/timezone  /etc/timezone

EXPOSE 24443

RUN apk add --no-cache build-base ruby ruby-dev

COPY --from=src-fluentd /fluentd/pkg/fluentd-*.gem /
# COPY --from=src-fluentd /usr/lib/ruby/gems/2.7.0/* /usr/lib/ruby/gems/2.7.0/
# COPY --from=src-fluentd /usr/bin/fluent* /usr/bin/

RUN gem install /fluentd-*.gem etc bigdecimal json webrick

RUN fluentd --setup /etc/fluentd \
 && mkdir -p /var/logs/pods

RUN apk del ruby-dev build-base

ENTRYPOINT ["/usr/bin/fluentd", "--config"]
CMD ["/etc/fluentd/fluent.conf", "-vv"]
