#!/bin/bash

# Ensure dependencies are installed
sudo apt update
sudo apt install -y net-tools docker.io finger

# Make scripts executable
chmod +x devopsfetch.sh fetch_ports.sh fetch_docker.sh fetch_nginx.sh fetch_users.sh fetch_time.sh

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Service

[Service]
ExecStart=$(pwd)/devopsfetch.sh -t "2024-01-01 00:00:00" "2024-12-31 23:59:59"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable devopsfetch
sudo systemctl start devopsfetch
