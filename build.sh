#!/bin/bash

IMAGE=$1
TAG=$2
USERNAME=$3
PASSWORD=$4

docker build --network host -t $IMAGE:$TAG .
docker login -u="$USERNAME" -p="$PASSWORD"
docker push $IMAGE:$TAG