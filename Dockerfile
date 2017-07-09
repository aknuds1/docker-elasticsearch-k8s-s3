FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.0

RUN echo $ELASTIC_CONTAINER $JAVA_HOME

USER root
RUN mkdir /data
RUN chown -R elasticsearch:elasticsearch /data

WORKDIR /usr/share/elasticsearch

USER elasticsearch
COPY bin/elasticsearch_logging_discovery bin/
COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/
COPY run.sh bin/
RUN ./bin/elasticsearch-plugin install -b repository-s3

VOLUME ["/data"]
EXPOSE 9200 9300

CMD ["bin/run.sh"]
