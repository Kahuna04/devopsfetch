#!/bin/bash

# Path for log file
LOG_FILE="/var/log/devopsfetch.log"

# Ensure log file exists and is writable
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Function to append output to log file
log_output() {
    while IFS= read -r line; do
        echo "$(date): $line" | tee -a "$LOG_FILE"
    done
}

# Function to display help
show_help() {
    cat << EOF
Usage: ${0##*/} [-p [PORT]] [-d [CONTAINER]] [-n [DOMAIN]] [-u [USERNAME]] [-t [TIMERANGE]] [-c] [-h]
    -p [PORT]           Display all active ports or a specific port if provided.
    -d [CONTAINER]      List all Docker images and containers or a specific container if provided.
    -n [DOMAIN]         Display Nginx domain configurations or a specific domain if provided.
    -u [USERNAME]       List all users and their last login times or specific user info if provided.
    -t [TIMERANGE]      Display system activities within the specified time range.
    -c                  Run in continuous monitoring mode.
    -h                  Display this help and exit.
EOF
}

# Function for Ports Information
ports() {
    if [ -z "$1" ]; then
        echo "Displaying all active ports:" | log_output
        sudo netstat -tulnp | grep LISTEN | log_output
    else
        echo "Displaying information for port $1:" | log_output
        sudo netstat -tulnp | grep LISTEN | grep ":$1" | log_output
    fi
}

# Function for Docker Information
docker_info() {
    if [ -z "$1" ]; then
        echo "Displaying all Docker containers and images:" | log_output
        docker ps -a | log_output
        docker images | log_output
    else
        echo "Detailed information for Docker container $1:" | log_output
        docker inspect "$1" | log_output || echo "Error: No such object: $1" | log_output
    fi
}

# Function for Nginx Configuration
nginx_config() {
    if [ -z "$1" ]; then
        echo "Displaying all Nginx configurations:" | log_output
        grep server_name /etc/nginx/sites-enabled/* -R | log_output
    else
        echo "Detailed configuration for Nginx domain $1:" | log_output
        grep -R "server_name $1" /etc/nginx/sites-enabled/* | log_output
    fi
}

# Function for User Logins
list_users_and_last_logins() {
    echo "Users and Last Logins:" | log_output
    echo "User     Terminal  Login Time          Duration" | log_output
    echo "-------------------------------------------------" | log_output
    last -a | awk '{if ($1 != last_user) {printf "%-8s %-9s %-19s %-10s\n", $1, $2, $3" "$4" "$5, $6; last_user=$1}}' | log_output
}

get_user_info() {
    local username=$1
    echo "Information for User $username:" | log_output
    finger $username | log_output
}

user_logins() {
    if [ -z "$1" ]; then
        list_users_and_last_logins
    else
        get_user_info "$1"
    fi
}

# Function for Time Range Logs
time_range() {
    if [ -z "$1" ]; then
        echo "Error: -t requires a time range argument." | log_output
        show_help
        exit 1
    else
        echo "Displaying logs for time range $1:" | log_output
        journalctl --since "$1" | log_output
    fi
}

# Continuous monitoring mode
continuous_monitoring() {
    while true; do
        ports
        docker_info
        nginx_config
        user_logins
        sleep 300  # Run every 5 minutes
    done
}

# Parse command-line options
while getopts ":p::d::n::u::t:ch" opt; do
    case "$opt" in
        p) ports "$OPTARG" ;;
        d) docker_info "$OPTARG" ;;
        n) nginx_config "$OPTARG" ;;
        u) user_logins "$OPTARG" ;;
        t) time_range "$OPTARG" ;;
        c) continuous_monitoring ;;
        h) show_help
           exit 0 ;;
        \?)
            show_help
            exit 1 ;;
    esac
done

# Default to show help if no arguments
if [ $OPTIND -eq 1 ]; then
    show_help
    exit 1
fi
