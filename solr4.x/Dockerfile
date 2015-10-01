FROM java:openjdk-8-jre

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Solr version
ENV SOLR_VERSION 4.10.4
ENV SOLR_MIRROR http://archive.apache.org/dist/lucene/solr
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_COLLECTION_PATH /opt/solr/$SOLR/example/solr/collection1

# Download and unpack solr, symlink configuration and data directories
RUN curl -sSL --create-dirs $SOLR_MIRROR/$SOLR_VERSION/$SOLR.tgz -o /opt/solr/$SOLR.tgz && \
	tar -C /opt/solr/ --extract --file /opt/solr/$SOLR.tgz && \
	rm /opt/solr/$SOLR.tgz && \
	ln -s /var/lib/solr/conf $SOLR_COLLECTION_PATH/conf && \
	ln -s /var/lib/solr/data $SOLR_COLLECTION_PATH/data

# Copy scripts and configs
COPY ./solr/conf /var/lib/solr/conf

# Persistent volume for solr data
VOLUME ["/var/lib/solr/data"]

EXPOSE 8983

WORKDIR /opt/solr/$SOLR/example

CMD ["java", "-jar", "start.jar"]
