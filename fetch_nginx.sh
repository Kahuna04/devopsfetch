#!/bin/bash

list_nginx_domains() {
    local nginx_conf_dir="/etc/nginx/sites-available/"
    if [ ! -d "$nginx_conf_dir" ]; then
        echo "Nginx configuration directory $nginx_conf_dir does not exist."
        return 1
    fi

    echo "Nginx Domains and Ports:"
    grep -H -E 'server_name|listen' "${nginx_conf_dir}"* | awk '
        /server_name/ {domain=$2}
        /listen/ {print "Domain:", domain, "Port:", $2}
    ' | column -t -s ' '
}

get_nginx_domain_info() {
    local domain=$1
    local nginx_conf_dir="/etc/nginx/sites-available/"
    if [ ! -d "$nginx_conf_dir" ]; then
        echo "Nginx configuration directory $nginx_conf_dir does not exist."
        return 1
    fi

    echo "Nginx Configuration for $domain:"
    grep -A 10 "$domain" "${nginx_conf_dir}"*
}

# Ensure script is executable
chmod +x fetch_nginx.sh

