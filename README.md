# fluentd-docker

[![Build status](https://badge.buildkite.com/15ebcb1d9de0f30fda036f632eb7220fcd9ae577498b7e99e8.svg)](https://buildkite.com/everyday-hero/fluentd)

```sh
docker build -t quay.io/everydayhero/fluentd .

docker run --rm -it \
  --name fluentd \
  -e AWS_ACCESS_KEY=AKIAABCDEFGHIJQLMNOP \
  -e AWS_SECRET_KEY=vby3y8b34b8th15isn0tar3alkey9brv4b \
  -e AWS_REGION=us-east-1 \
  -e KINESIS_STREAM=log-stream \
  -p 24224:24224 \
  -v `pwd`/fluent.conf:/fluentd/etc/fluent.conf \
  quay.io/everydayhero/fluentd

docker run -it --rm \
  --name fluentd-test \
  --log-driver=fluentd \
  --log-opt=tag="{{.Name}}.{{.ID}}" \
  --log-opt=labels=app.name,app.command,app.env \
  --log-opt=fluentd-tag=docker.{{.ID}} \
  --label app.name=foo \
  --label app.command=serve \
  --label app.env=staging \
  alpine \
  date
```
