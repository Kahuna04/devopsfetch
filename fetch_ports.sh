#!/bin/bash

get_active_ports() {
    echo "Active Ports and Services:"
    netstat -tuln
}

get_port_info() {
    local port_number=$1
    echo "Information for Port $port_number:"
    netstat -tuln | grep ":$port_number"
}
