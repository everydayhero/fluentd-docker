FROM fluent/fluentd:latest
MAINTAINER Everydayhero <edh-dev@everydayhero.com.au>

RUN gem install \
      fluent-plugin-docker_metadata_filter \
      fluent-plugin-kinesis \
      fluent-plugin-cloudwatch-logs \
      --no-rdoc --no-ri && \
    gem sources --clear-all

COPY fluent.conf /fluentd/etc/
COPY plugins /fluentd/plugins/

EXPOSE 5140
EXPOSE 5170
EXPOSE 24224

USER root

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
