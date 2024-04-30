ARG FROM
FROM ${FROM}

ARG VERSION
ARG SOLR_DEFAULT_CONFIG_SET

ARG INCLUDE_EXTRAS

ENV VERSION=${VERSION}
ENV SOLR_DEFAULT_CONFIG_SET=${SOLR_DEFAULT_CONFIG_SET}
ENV INCLUDE_EXTRAS=${INCLUDE_EXTRAS}
ENV SOLR_HEAP="1024m"
ENV SOLR_HOME="/opt/solr/server/solr"

USER root
COPY configsets /opt/docker-solr/configsets
COPY scripts/healthcheck.sh /scripts/healthcheck.sh
COPY scripts/docksal-preinit /scripts/docksal-preinit

RUN set -xe; \
	apt-get update && \
	apt-get -y install sudo; \
	echo "solr ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/solr; \
	rm -rf /var/lib/apt/lists/*

RUN set -xe; \
	ln -s /opt/solr/dist /opt/dist; \
	ln -s /opt/solr/contrib /opt/contrib; \
	# Needed for 9.x and above
	[ -f "/opt/solr/docker/scripts/docker-entrypoint.sh" ] && sed -i '/exec "$@"/i . docksal-preinit' /opt/solr/docker/scripts/docker-entrypoint.sh; \
	[ -d "/opt/solr/docker/scripts" ] && mv /scripts/healthcheck.sh /scripts/docksal-preinit /opt/solr/docker/scripts/; \
	# Needed for 8.x and below
	[ -f "/opt/docker-solr/scripts/docker-entrypoint.sh" ] && sed -i '/exec "$@"/i . docksal-preinit' /opt/docker-solr/scripts/docker-entrypoint.sh; \
	[ -d "/opt/docker-solr/scripts/docker" ] && mv /scripts/healthcheck.sh /scripts/docksal-preinit /opt/docker-solr/scripts/; \
	chown -R solr:solr /opt/docker-solr /opt/solr/server/solr

RUN set -xe; \
	if [[ "${INCLUDE_EXTRAS}" == "1" ]]; then \
		cd /opt/solr; \
		cp contrib/analysis-extras/lib/*.jar server/solr-webapp/webapp/WEB-INF/lib/; \
		cp contrib/analysis-extras/lucene-libs/*.jar server/solr-webapp/webapp/WEB-INF/lib/; \
	fi

USER solr

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["healthcheck.sh"]
