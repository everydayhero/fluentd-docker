# Fluentd-docker

This kicks off the unified log-collector we discussed last week. Currently, it is designed to accept JSON input over UDP, such as that which may be forwarded by [journalctl](http://www.freedesktop.org/software/systemd/man/journalctl.html).

```
journalctl -o json -f | ncat -u localhost 5160
```

Once out of POC stage, we'll want to get this into a unit file of its own. The anticipated complications with this will be around non-root access to the journal, and teaching ncat to ignore connection errors.

To start the forwarder, clone this repo, then build the docker image (it is not yet available in a docker registry). You'll then want to set ENV variables to teach the container some secrets about where to find storage locations. S3, ES and Loggly are currently available.

```sh
docker build -t fluentd .
docker run \
  --rm -it \
  -p 5160:5160/udp \
  -e "ELASTICSEARCH_HOST=foo" \
  -e "ELASTICSEARCH_PORT=foo" \
  -e "LOGGLY_TOKEN=foo" \
  -e "AWS_KEY=foo" \
  -e "AWS_SECRET=foo" \
  -e "S3_BUCKET=foo" \
  -e "S3_ENDPOINT=foo" \
  -e "S3_PATH=foo" \
  fluentd
