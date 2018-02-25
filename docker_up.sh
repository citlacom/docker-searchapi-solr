#!/usr/bin/env bash

# Service name defined in docker-compose.yml
SERVICE_NAME=${1}

docker-compose up ${SERVICE_NAME}
# Set core data permissions to solr user / group.
docker-compose exec --user=root ${SERVICE_NAME} chown -R solr:solr /opt/solr/server/solr/mycores/search/data
