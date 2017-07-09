#!/bin/sh
export MINIMUM_MASTER_NODES=2
gosu elasticsearch /elasticsearch/bin/elasticsearch-plugin install repository-s3
