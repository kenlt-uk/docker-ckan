#!/usr/bin/env bash

docker-compose -f docker-compose.dev.yml down

docker ps -a -f status=exited -f status=created | grep docker-ckan | awk '{ print $1 }' | xargs docker rm 
docker ps -a -f status=exited -f status=created | grep alphagov | awk '{ print $1 }' | xargs docker rm 
docker ps -a -f status=exited -f status=created | grep solr | awk '{ print $1 }' | xargs docker rm 
docker ps -a -f status=exited -f status=created | grep postgis | awk '{ print $1 }' | xargs docker rm 
docker ps -a -f status=exited -f status=created | grep alpine | awk '{ print $1 }' | xargs docker rm 

docker images | grep docker-ckan | awk '{ print $3 }' | xargs docker rmi
docker images | grep alphagov | awk '{ print $3 }' | xargs docker rmi
docker images | grep solr | awk '{ print $3 }' | xargs docker rmi
docker images | grep postgis | awk '{ print $3 }' | xargs docker rmi
docker images | grep alpine | awk '{ print $3 }' | xargs docker rmi
