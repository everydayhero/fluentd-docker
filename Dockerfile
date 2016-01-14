FROM fluent/fluentd:latest
MAINTAINER Everydayhero <edh-dev@everydayhero.com.au>

RUN gem install \
    fluent-plugin-elasticsearch \
    fluent-plugin-kinesis \
    fluent-plugin-s3 \
    fluent-plugin-secure-forward \
    --no-rdoc --no-ri

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
