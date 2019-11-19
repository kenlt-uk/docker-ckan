## Packaging kentsang/alpine-geos

docker save kentsang/alpine-geos:latest > image.tar

docker load < image.tar

docker push kentsang/alpine-geos:latest 
