#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"
exec > >(tee -a $LOG_FILE) 2>&1

source ./fetch_ports.sh
source ./fetch_docker.sh
source ./fetch_nginx.sh
source ./fetch_users.sh
source ./fetch_time.sh

display_help() {
    echo "Usage: $0 [option] [argument]"
    echo "Options:"
    echo "  -p, --port [port_number]    Display active ports or specific port information"
    echo "  -d, --docker [container_name] List Docker images and containers or specific container info"
    echo "  -n, --nginx [domain]        Display Nginx domains or specific domain info"
    echo "  -u, --users [username]      List users and last logins or specific user info"
    echo "  -t, --time [start_time] [end_time] Display activities within a specified time range"
    echo "  -h, --help                  Display this help message"
}

while [[ "$1" != "" ]]; do
    case $1 in
        -p | --port )
            shift
            if [ "$1" ]; then
                get_port_info $1
            else
                get_active_ports
            fi
            exit
            ;;
        -d | --docker )
            shift
            if [ "$1" ]; then
                get_container_info $1
            else
                list_docker_images_and_containers
            fi
            exit
            ;;
        -n | --nginx )
            shift
            if [ "$1" ]; then
                get_nginx_domain_info $1
            else
                list_nginx_domains
            fi
            exit
            ;;
        -u | --users )
            shift
            if [ "$1" ]; then
                get_user_info $1
            else
                list_users_and_last_logins
            fi
            exit
            ;;
        -t | --time )
            shift
            if [ "$1" ] && [ "$2" ]; then
                get_activities_in_time_range $1 $2
            else
                echo "Please provide both start and end time."
                exit 1
            fi
            exit
            ;;
        -h | --help )
            display_help
            exit
            ;;
        * )
            display_help
            exit 1
    esac
    shift
done

display_help
