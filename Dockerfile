FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.0

USER root
RUN mkdir /data
RUN chown -R elasticsearch:elasticsearch /data

RUN yum update -y && yum install -y gosu && yum clean all

WORKDIR /usr/share/elasticsearch

USER elasticsearch
# Temporarily move config out of the way before installing plugin as installation will fail
# otherwise
RUN mv config config.bak && ./bin/elasticsearch-plugin install -b repository-s3 && \
mv config.bak config
COPY bin/elasticsearch_logging_discovery bin/
COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/
COPY run.sh bin/

VOLUME ["/data"]
EXPOSE 9200 9300

USER root
CMD ["bin/run.sh"]
