#!/usr/bin/env bash

# Service name defined in docker-compose.yml
SERVICE_NAME=${1}
VOLUME_NAME="volume_${SERVICE_NAME}"

if [[ "$SERVICE_NAME" == '' ]]; then
  echo "The argument service name is required."
  exit 1
fi

echo "Creating '${VOLUME_NAME}'..."

# Create the service volume.
docker volume create --name=${VOLUME_NAME}
docker create --rm --name temporal --user root -v ${VOLUME_NAME}:/search solr chown -R 8983:8983 /search

echo "Copying config files..."
docker cp ./config/drupal7/core.properties temporal:/search/core.properties
docker cp ./config/drupal7/solr-6.x temporal:/search/conf
docker cp ./data temporal:/search/data
docker start temporal

echo "Composing '${SERVICE_NAME}' service container."
docker-compose up ${SERVICE_NAME}
