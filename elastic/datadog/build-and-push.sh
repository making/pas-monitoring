#!/bin/bash
set -e

LOGSTASH_VERSION=7.5.1

docker build -t making/logstash-datadog:${LOGSTASH_VERSION} .
docker push making/logstash-datadog:${LOGSTASH_VERSION}
