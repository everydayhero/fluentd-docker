# Fluentd-docker

[![Build status](https://badge.buildkite.com/15ebcb1d9de0f30fda036f632eb7220fcd9ae577498b7e99e8.svg)](https://buildkite.com/everyday-hero/fluentd)

```sh
docker build -t everydayhero/fluentd .

docker run -it \
  --rm \
  --name fluent-testing \
  --privileged \
  -e "KINESIS_STREAM=foo" \
  -e "AWS_KEY=foo" \
  -e "AWS_SECRET=foo" \
  -e "AWS_REGION=foo" \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v /var/log:/var/log \
  -v /var/run/docker.sock:/var/run/docker.sock \
  everydayhero/fluentd
```
