#!/bin/bash

list_nginx_domains() {
    echo "Nginx Domains and Ports:"
    grep 'server_name\|listen' /etc/nginx/sites-available/* | awk '{print $1, $2}'
}

get_nginx_domain_info() {
    local domain=$1
    echo "Nginx Configuration for $domain:"
    grep -A 10 "$domain" /etc/nginx/sites-available/*
}
