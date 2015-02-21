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
    fluent-plugin-loggly \
    fluent-plugin-elasticsearch \
    --no-rdoc --no-ri

RUN mkdir /etc/fluent
ADD fluent.conf.erb /etc/fluent/

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5160
CMD ["/usr/local/bundle/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
