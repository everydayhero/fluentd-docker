FROM ruby:2.2.0
MAINTAINER EverydayHero <edh-dev@everydayhero.com.au>

# See http://docs.fluentd.org/en/articles/before-install
RUN ulimit -n 65536

RUN apt-get update && apt-get install -y \
  make \
  libcurl4-gnutls-dev \
  && rm -rf /var/lib/apt/lists/*

RUN gem install \
    fluent-plugin-s3 \
    fluent-plugin-elasticsearch \
    fluent-plugin-kinesis \
    --no-rdoc --no-ri

RUN mkdir -p /etc/fluent/plugin
ADD fluent.conf.erb /etc/fluent/
ADD plugins/* /etc/fluent/plugin/

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5170
CMD ["/usr/local/bundle/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
