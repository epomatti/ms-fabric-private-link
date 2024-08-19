#!/bin/bash

repository="$acr.azurecr.io/fabricapp:latest"
local="fabricapp-local"

az acr login --name "$acr
docker build -t $local .
docker tag $local $repository
docker push $repository
