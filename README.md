## DevOps Fetch Tool

The DevOps Fetch Tool (`devopsfetch.sh`) is a comprehensive system information gathering script designed to streamline system monitoring and analysis. It provides insights into various critical aspects of a server's operation, including active ports, Docker container status, Nginx configurations, user login history, and system activity logs.

The tool offers both standalone execution and continuous monitoring capabilities through integration with systemd.

### Key Features

- **Port Analysis:** List all active ports or retrieve detailed information about a specific port.
- **Docker Container Management:** Display all Docker containers and images, or obtain detailed information about a specific container.
- **Nginx Configuration Inspection:** Show all Nginx domain configurations or retrieve details for a specific domain.
- **User Login Tracking:** List all users and their last login times, or retrieve specific user login details.
- **Time-Based Log Retrieval:** Display system logs for a specified time range.
- **Continuous Monitoring:**  Automatically logs updated system information every 5 minutes when run as a systemd service.

### System Requirements

- Linux-based operating system (tested on Ubuntu 20.04)
- Docker
- Nginx
- net-tools
- systemd (for continuous monitoring)

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Mobey-eth/Hng_stage_5-midway-task.git
   cd devopsfetch
   ```

2. **Make the Script Executable:**

   ```bash
   sudo chmod +x devopsfetch.sh
   ```

3. **(Optional) Move the Script:**

   ```bash
   sudo mv devopsfetch.sh /usr/local/bin/
   ```

4. **Set Up Log File:**

   ```bash
   sudo touch /var/log/devopsfetch.log
   sudo chmod 644 /var/log/devopsfetch.log
   ```

5. **Install Dependencies:**

   ```bash
   sudo apt-get update
   sudo apt-get install net-tools docker.io nginx
   ```

### Systemd Service Configuration

For continuous monitoring, configure `devopsfetch.sh` as a systemd service:

1. **Create Service File:**

   ```bash
   sudo nano /etc/systemd/system/devopsfetch.service
   ```

   Add the following configuration:

   ```ini
   [Unit]
   Description=DevOps Fetch Service
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/devopsfetch.sh -c
   Restart=on-failure
   User=root
   WorkingDirectory=/usr/local/bin
   StandardOutput=append:/var/log/devopsfetch.log
   StandardError=append:/var/log/devopsfetch.log

   [Install]
   WantedBy=multi-user.target
   ```

2. **Reload systemd:**

   ```bash
   sudo systemctl daemon-reload
   ```

3. **Enable and Start Service:**

   ```bash
   sudo systemctl enable devopsfetch.service
   sudo systemctl start devopsfetch.service
   ```

### Testing

#### Manual Testing

**Individual Function Testing:**

- **Ports:**
    - List all active ports: `sudo /usr/local/bin/devopsfetch.sh -p`
    - Get details for a specific port (e.g., port 80): `sudo /usr/local/bin/devopsfetch.sh -p 80`

- **Docker:**
    - List all Docker images and containers: `sudo /usr/local/bin/devopsfetch.sh -d`
    - Get details for a specific container (e.g., "test-nginx"): `sudo /usr/local/bin/devopsfetch.sh -d test-nginx`

- **Nginx:**
    - Display all Nginx configurations: `sudo /usr/local/bin/devopsfetch.sh -n`
    - Get details for a specific domain (e.g., "example.com"): `sudo /usr/local/bin/devopsfetch.sh -n example.com`

- **Users:**
    - List all users and last login times: `sudo /usr/local/bin/devopsfetch.sh -u`
    - Get details for a specific user (replace "username"): `sudo /usr/local/bin/devopsfetch.sh -u username`

- **Time Range Logs:**
    - Display logs for a specific time range (e.g., "1 hour ago"): `sudo /usr/local/bin/devopsfetch.sh -t "1 hour ago"`

**Continuous Monitoring Mode:**

- Start the script in continuous monitoring mode: `sudo /usr/local/bin/devopsfetch.sh -c`
- Monitor the output using `sudo tail -f /var/log/devopsfetch.log`.
- Stop monitoring with Ctrl+C.

**Review Log Files:**

- Check the log file for recorded information: `sudo less /var/log/devopsfetch.log`

#### Systemd Service Testing

- Check service status: `sudo systemctl status devopsfetch.service`
- View service logs: `sudo tail -f /var/log/devopsfetch.log`
- Restart the service if needed: `sudo systemctl restart devopsfetch.service`

### Conclusion

The DevOps Fetch Tool is a valuable asset for system administrators and DevOps engineers, providing a comprehensive and automated approach to system monitoring and analysis. Its continuous monitoring capabilities, coupled with detailed information retrieval, streamline system management and troubleshooting.
