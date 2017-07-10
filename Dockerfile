FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.0

USER root
RUN mkdir /data
RUN chown -R elasticsearch:elasticsearch /data

WORKDIR /usr/share/elasticsearch

USER elasticsearch
# Temporarily move config out of the way before installing plugin as installation will fail
# otherwise
RUN mv config config.bak && ./bin/elasticsearch-plugin install -b repository-s3 && \
mv -f config.bak/* config/ && rmdir config.bak
COPY bin/elasticsearch_logging_discovery bin/
COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/
COPY run.sh bin/

VOLUME ["/data"]
EXPOSE 9200 9300

USER root

ENV GOSU_VERSION 1.10
RUN set -ex; \
	yum -y install epel-release; \
	yum -y install wget dpkg; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
  # verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu; \
	rm -r "$GNUPGHOME" /tmp/gosu.asc; \
	chmod +x /usr/bin/gosu; \
  # verify that the binary works
	gosu nobody true; \
	yum -y remove wget dpkg; \
	yum clean all

RUN chown -R elasticsearch:elasticsearch config
CMD ["bin/run.sh"]
