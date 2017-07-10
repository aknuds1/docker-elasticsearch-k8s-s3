#!/bin/bash
whoami
ls -ld config/
ls -l config/
cat config/elasticsearch.yml
cat config/jvm.options
cat config/log4j2.properties
sysctl -w vm.max_map_count=262144
./bin/elasticsearch_logging_discovery >> ./config/elasticsearch.yml
su - elasticsearch
exec ./bin/es-docker
