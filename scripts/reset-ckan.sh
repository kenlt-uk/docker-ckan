#!/usr/bin/env bash

echo "Docker compose down to remove containers"
docker-compose -f docker-compose.dev.yml down

function remove_volumes {
    echo "Removing volumes..."
    ./scripts/reset-volumes.sh
}

function remove_postdev {
    echo "Removing postdev images..."
    docker images | grep "docker-ckan_ckan-postdev .*" | awk '{print $3}' | xargs docker rmi
}

function remove_ckan {
    remove_postdev
    echo "Removing ckan images..."
    docker images | grep "alphagov/ckan .*" | awk '{print $3}' | xargs docker rmi
}

function remove_ckan_dev {
    remove_ckan
    echo "Removing ckan-dev images..."
    docker images | grep "alphagov/ckan-dev .*" | awk '{print $3}' | xargs docker rmi
}

function remove_ckan_base {
    remove_ckan_dev
    echo "Removing ckan-base images..."
    docker images | grep "alphagov/ckan-base .*" | awk '{print $3}' | xargs docker rmi
}

if [[ ! -z $1 && $1 == 'help' ]]; then
    echo "Usage: ./scripts/reset-ckan.sh <images from (postdev, ckan, ckan-dev, ckan-base)> <remove volumes (Yn)> "
else

    while True; do
        remove=$1
        if [[ -z $remove ]]; then
            read -p "remove images (postdev, ckan, ckan-dev, ckan-base): " remove
        fi

        if [[ $remove == "postdev" ]]; then
            remove_postdev
            break
        elif [[ $remove == "ckan" ]]; then
            remove_ckan
            break
        elif [[ $remove == "ckan-dev" ]]; then
            remove_ckan_dev
            break
        elif [[ $remove == "ckan-base" ]]; then
            remove_ckan_base
            break
        else 
            echo "$remove not recognised"
        fi
    done

    remove_volumes=$2

    if [[ -z $remove_volumes ]]; then
        read -p "remove volumes (Yn): " remove_volumes

        if [[ -z $remove_volumes ]]; then
            remove_volumes=Y
        fi
    fi

    if [[ $remove_volumes == "Y" ]]; then
        remove_volumes
    else
        echo "Volumes not removed"
    fi

fi
