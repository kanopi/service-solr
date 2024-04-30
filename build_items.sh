#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

REPO=devkteam/solr
SOLR_DEFAULT_CONFIG_SET="search_api_solr_4.3.0"

build() {
    git checkout -- configsets
    VERSION=${VERSION} scripts/prepare_configsets.sh
    TAG=$(echo "${REPO}:${TAG}" | sed "s#,# -t $REPO:#g")
    docker \
        buildx \
        build \
        --push \
        --platform linux/amd64,linux/arm64 \
        -t ${TAG} \
        --build-arg INCLUDE_EXTRAS=${INCLUDE_EXTRAS} \
        --build-arg FROM=${FROM} \
        --build-arg VERSION=${VERSION} \
        --build-arg SOLR_DEFAULT_CONFIG_SET=${SOLR_DEFAULT_CONFIG_SET} \
        .
}

TAG=8,8.11,8.11.2 VERSION=8.11 FROM=solr:8.11.2-slim build
TAG=8-extras,8.11-extras,8.11.2-extras VERSION=8.11-extras FROM=solr:8.11.2-slim INCLUDE_EXTRAS=1 build
TAG=9.3,9.3.0 VERSION=9.3 FROM=solr:9.3.0-slim build
TAG=9.3-extras,9.3.0-extras VERSION=9.3-extras FROM=solr:9.3.0-slim INCLUDE_EXTRAS=1 build
TAG=9,9.4,9.4.0 VERSION=9.4 FROM=solr:9.4.0-slim build
TAG=9-extras,9.4-extras,9.4.0-extras VERSION=9.4-extras FROM=solr:9.4.0-slim INCLUDE_EXTRAS=1 build
