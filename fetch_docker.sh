#!/bin/bash

list_docker_images_and_containers() {
    echo "Docker Images:"
    docker images
    echo "Docker Containers:"
    docker ps -a
}

get_container_info() {
    local container_name=$1
    echo "Information for Container $container_name:"
    docker inspect $container_name
}
