#!/bin/bash

region="us-east-2"
tag="javaapp"
name="apprunner-xray"

docker build -t $name .
docker tag $name "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"
docker push "$account.dkr.ecr.$region.amazonaws.com/$name:$tag"



az acr login --name "$acr"
docker build -t $name .
docker tag $name "$acr.azurecr.io/litware-fabric-app:latest"
docker push "$acr.azurecr.io/litware-fabric-app:latest"
