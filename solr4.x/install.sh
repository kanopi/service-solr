#!/bin/bash

mkdir -p /opt/solr

# Download and unpack solr
wget --progress=bar:force --output-document=/opt/solr/$SOLR.tgz $SOLR_MIRROR/$SOLR_VERSION/$SOLR.tgz && \
tar -C /opt/solr/ --extract --file /opt/solr/$SOLR.tgz && \
rm /opt/solr/$SOLR.tgz

# Symlink configuration and data directories
ln -s /var/lib/solr/conf $SOLR_COLLECTION_PATH/conf
ln -s /var/lib/solr/data $SOLR_COLLECTION_PATH/data
