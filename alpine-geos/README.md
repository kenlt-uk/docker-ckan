## Packaging govuk/alpine-geos

docker save govuk/alpine-geos:latest > image.tar
docker load < image.tar
docker push govuk/alpine-geos:latest 
