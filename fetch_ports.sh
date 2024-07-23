#!/bin/bash

# Function to list all active ports and services
get_active_ports() {
    echo -e "USER\tPORT\tSERVICE"
    netstat -tuln | awk 'NR>2 {print $1"\t"$4"\t"$6}'
}

# Function to display detailed information about a specific port
get_port_info() {
    local port=$1
    if [[ -z "$port" ]]; then
        echo "Port number is required."
        return
    fi
    
    # Check if port is active
    local port_info=$(netstat -tuln | grep "$port")
    
    if [[ -z "$port_info" ]]; then
        echo "No information found for port $port."
    else
        echo -e "USER\tPORT\tSERVICE"
        echo "$port_info" | awk '{print $1"\t"$4"\t"$6}'
    fi
}

# Export functions to be available in devopsfetch.sh
export -f get_active_ports
export -f get_port_info

