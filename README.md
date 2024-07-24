## DevOps Fetch Tool Documentation

### Introduction

`devopsfetch` is a bash-based command-line tool designed to streamline system information gathering for DevOps professionals. It retrieves data on active ports, user logins, Nginx configurations, Docker images, and container statuses.  `devopsfetch` also offers continuous monitoring and logging through a systemd service.

### Installation and Configuration

#### Prerequisites

Ensure the following dependencies are installed on your system:

* `net-tools`: For network-related operations.
* `docker.io`: For interacting with Docker.
* `finger`: For retrieving user information.

Install these dependencies using your package manager:

```bash
sudo apt update
sudo apt install -y net-tools docker.io finger
```

#### Installation Steps

1. **Clone the Repository:**

   Clone the `devopsfetch` repository from GitHub:

   ```bash
   git clone https://github.com/kahuna04/devopsfetch.git
   cd devopsfetch
   ```

2. **Make Scripts Executable:**

   Grant execute permissions to all scripts within the directory:

   ```bash
   chmod +x devopsfetch fetch_ports.sh fetch_docker.sh fetch_nginx.sh fetch_users.sh fetch_time.sh
   ```

3. **Install the Systemd Service:**

   Run the installation script to set up the systemd service:

   ```bash
   ./install.sh
   ```

This script will create a service file at `/etc/systemd/system/devopsfetch.service`, enabling continuous monitoring and logging.

#### Configuration

The `devopsfetch.service` file handles the service configuration. You can modify this file to adjust logging settings or other parameters as needed.

### Usage

`devopsfetch` accepts several command-line flags to retrieve specific system information.

#### Command-Line Flags

* **`-p` (Ports):**

   * `./devopsfetch -p`: Display all active ports.
   * `./devopsfetch -p <port_number>`: Display information about a specific port.

* **`-d` (Docker):**

   * `./devopsfetch -d`: List all Docker images and containers.
   * `./devopsfetch -d <container_name>`: Provide detailed information about a specific container.

* **`-n` (Nginx):**

   * `./devopsfetch -n`: Display all Nginx domains and their ports.
   * `./devopsfetch -n <domain>`: Provide detailed configuration information for a specific domain.

* **`-u` (Users):**

   * `./devopsfetch -u`: List all users and their last login times.
   * `./devopsfetch -u <username>`: Provide detailed information about a specific user.

* **`-t` (Time Range):**

   * `./devopsfetch -t "2024-01-01 00:00:00" "2024-12-31 23:59:59"`: Display activities within a specified time range.

* **`-h` (Help):**

   * `./devopsfetch -h`: Display a help message with available flags and usage instructions.

### Logging

#### Log File

`devopsfetch` logs its activities to `/var/log/devopsfetch.log`. This file captures all retrieved information and any errors encountered during execution.

#### Log Rotation

Logrotate is configured to manage the log file, ensuring disk space efficiency. The configuration file, located at `/etc/logrotate.d/devopsfetch`, rotates logs daily, retaining up to 7 days of logs, and compresses them for storage optimization.

#### Viewing Logs

Use the following commands to view the logs:

* **Entire Log File:**

   ```bash
   cat /var/log/devopsfetch.log
   ```

* **Last 10 Lines:**

   ```bash
   tail -n 10 /var/log/devopsfetch.log
   ```

* **Real-Time Monitoring:**

   ```bash
   tail -f /var/log/devopsfetch.log
   ```

### Managing the Systemd Service

Control the `devopsfetch` service using systemd commands:

* **Start:**

   ```bash
   sudo systemctl start devopsfetch
   ```

* **Stop:**

   ```bash
   sudo systemctl stop devopsfetch
   ```

* **Restart:**

   ```bash
   sudo systemctl restart devopsfetch
   ```

* **Status:**

   ```bash
   sudo systemctl status devopsfetch
   ```

### Conclusion

`devopsfetch` is a powerful tool for DevOps engineers to efficiently gather and monitor essential system information. By following this documentation, you can leverage its capabilities to enhance your server management and troubleshooting workflows.
