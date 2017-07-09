#!/bin/sh
export MINIMUM_MASTER_NODES=2
export HTTP_PORT=9200
export TRANSPORT_PORT=9300
export NODE_DATA=true
export NODE_MASTER=true
gosu elasticsearch /elasticsearch/bin/elasticsearch-plugin install -b repository-s3
