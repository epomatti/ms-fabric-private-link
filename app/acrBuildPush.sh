#!/bin/bash

if [[ -z "${CONTAINER_REGISTRY}" ]]; then
  echo "CONTAINER_REGISTRY is not set. Export the variable with the ACR name."
  echo "Exiting..."
  exit 1
else
  acr="${CONTAINER_REGISTRY}"
fi

repository="$acr.azurecr.io/fabricapp:latest"
local="fabricapp-local"

az acr login --name "$acr
docker build -t $local .
docker tag $local $repository
docker push $repository
