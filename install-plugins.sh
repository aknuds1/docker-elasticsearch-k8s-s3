#!/bin/sh
export MINIMUM_MASTER_NODES=2
export HTTP_PORT=9200
export TRANSPORT_PORT=9300
gosu elasticsearch /elasticsearch/bin/elasticsearch-plugin install repository-s3
