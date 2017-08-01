FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.1

USER root

RUN mkdir /data
RUN chown -R elasticsearch:elasticsearch /data

WORKDIR /usr/share/elasticsearch

VOLUME ["/data"]
EXPOSE 9200 9300

USER elasticsearch
# Temporarily move config out of the way before installing plugin as installation will fail
# otherwise
RUN mv config config.bak && ./bin/elasticsearch-plugin install -b repository-s3 && \
mv -f config.bak/* config/ && rmdir config.bak
COPY bin/elasticsearch_logging_discovery bin/
COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/
COPY run.sh bin/

USER root
RUN chown -R elasticsearch:elasticsearch config
CMD ["bin/run.sh"]
