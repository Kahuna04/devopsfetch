#!/bin/bash

NGINX_SITES_AVAILABLE="/etc/nginx/sites-available/"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled/"

list_nginx_domains() {
    if [ -d "$NGINX_SITES_AVAILABLE" ]; then
        printf "%-20s %-30s %-30s\n" "Domain" "Proxy" "Conf File"
        printf "%-20s %-30s %-30s\n" "------" "-----" "---------"
        
        for site in $NGINX_SITES_AVAILABLE*; do
            domain=$(basename "$site")
            proxy=$(grep -Eo 'proxy_pass http://[^;]+' "$site" | awk '{print $2}' | head -n 1)
            port=$(grep -Eo 'listen [0-9]{1,5};' "$site" | grep -Eo '[0-9]{1,5}' | head -n 1)

            if [ -z "$proxy" ]; then
                proxy="localhost:$port"
            fi
            
            conf_file="$NGINX_SITES_ENABLED$domain"

            printf "%-20s %-30s %-30s\n" "$domain" "$proxy" "$conf_file"
        done
    else
        echo "Nginx configuration directory $NGINX_SITES_AVAILABLE does not exist."
    fi
}

get_nginx_domain_info() {
    domain="$1"
    site_file="$NGINX_SITES_AVAILABLE$domain"
    if [ -f "$site_file" ]; then
        echo "Nginx configuration for domain $domain:"
        cat "$site_file"
    else
        echo "Nginx configuration file for domain $domain does not exist."
    fi
}
