
#!/bin/bash

sudo apt update
sudo apt install -y net-tools docker.io finger

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "$SCRIPT_DIR/devopsfetch" "$SCRIPT_DIR/fetch_ports.sh" "$SCRIPT_DIR/fetch_docker.sh" "$SCRIPT_DIR/fetch_nginx.sh" "$SCRIPT_DIR/fetch_users.sh" "$SCRIPT_DIR/fetch_time.sh"

# Create log directory with proper permissions
sudo mkdir -p /var/log/devopsfetch
sudo chown "$(whoami):$(whoami)" /var/log/devopsfetch

# Copy the main script to /usr/local/bin
sudo cp "$SCRIPT_DIR/devopsfetch" /usr/local/bin/devopsfetch

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch
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
/var/log/devopsfetch/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 $(whoami) $(whoami)
    sharedscripts
    postrotate
        systemctl reload devopsfetch > /dev/null 2>/dev/null || true
    endscript
}
EOF

echo "Installation complete. The devopsfetch service is running and logging to /var/log/devopsfetch/devopsfetch.log."
