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
After=network.target

[Service]
ExecStart=$(pwd)/devopsfetch.sh
Restart=always
User=$(whoami)
Group=$(whoami)
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch
sudo systemctl start devopsfetch

# Configure logrotate
cat <<EOF | sudo tee /etc/logrotate.d/devopsfetch
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root adm
    sharedscripts
    postrotate
        systemctl reload devopsfetch > /dev/null 2>/dev/null || true
    endscript
}
EOF

echo "Installation complete. The devopsfetch service is running and logging to /var/log/devopsfetch.log."
