FROM java:openjdk-8-jre

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Solr version
ENV SOLR_VERSION 3.6.2
ENV SOLR_MIRROR http://archive.apache.org/dist/lucene/solr
ENV SOLR apache-solr-$SOLR_VERSION
ENV SOLR_COLLECTION_PATH /opt/solr/$SOLR/example/solr

# Persist volume for solr home
VOLUME ["/var/lib/solr/data"]

# Copy scripts and configs
COPY ./install.sh /opt/install.sh
COPY ./solr/conf /var/lib/solr/conf

# Download and install solr
RUN /opt/install.sh

EXPOSE 8983

WORKDIR /opt/solr/$SOLR/example

CMD ["java", "-jar", "start.jar"]
