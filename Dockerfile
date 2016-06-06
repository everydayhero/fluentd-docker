FROM fluent/fluentd:latest
MAINTAINER Everydayhero <edh-dev@everydayhero.com.au>

RUN gem install \
    fluent-plugin-color-stripper \
    fluent-plugin-docker_metadata_filter \
    fluent-plugin-kinesis \
    --no-rdoc --no-ri

EXPOSE 5140
EXPOSE 5170
EXPOSE 24224

USER root

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
