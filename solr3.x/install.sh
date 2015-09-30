#!/bin/bash

mkdir -p /opt/solr

# Download and unpack solr
wget --progress=bar:force --output-document=/opt/solr/$SOLR.tgz $SOLR_MIRROR/$SOLR_VERSION/$SOLR.tgz && \
tar -C /opt/solr/ --extract --file /opt/solr/$SOLR.tgz && \
rm /opt/solr/$SOLR.tgz

# Link configuration directory
rm -fr $SOLR_COLLECTION_PATH/conf
mkdir /var/lib/solr/conf
ln -s /var/lib/solr/conf $SOLR_COLLECTION_PATH/conf

# Link data directory
rm -fr $SOLR_COLLECTION_PATH/data
ln -s /var/lib/solr/data $SOLR_COLLECTION_PATH/data
