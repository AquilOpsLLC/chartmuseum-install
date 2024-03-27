#!/bin/bash

# Create a directory for ChartMuseum
mkdir -p chartmuseum

# Download the latest release of ChartMuseum
wget -O chartmuseum.tar.gz https://github.com/chartmuseum/chartmuseum/releases/download/v0.16.0/chartmuseum-v0.16.0-linux-amd64.tar.gz

# Extract the ChartMuseum archive
tar -zxvf chartmuseum.tar.gz -C chartmuseum --strip-components=1

# Move ChartMuseum binary to /usr/local/bin
sudo mv chartmuseum/chartmuseum /usr/local/bin/

# Create a configuration file for ChartMuseum
cat <<EOF | sudo tee /etc/chartmuseum/config.yaml
storage:
  filesystem:
    rootdirectory: /var/lib/chartmuseum
EOF

# Create directories for ChartMuseum storage
sudo mkdir -p /var/lib/chartmuseum

# Create a systemd service file for ChartMuseum
cat <<EOF | sudo tee /etc/systemd/system/chartmuseum.service
[Unit]
Description=ChartMuseum
After=network.target

[Service]
User=chartmuseum
Group=chartmuseum
ExecStart=/usr/local/bin/chartmuseum --port=8080 --storage="local" --storage-local-rootdir="/var/lib/chartmuseum" --debug
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start ChartMuseum service
sudo systemctl enable chartmuseum
sudo systemctl start chartmuseum

# Check ChartMuseum service status
sudo systemctl status chartmuseum

# Clean up
rm -rf chartmuseum chartmuseum.tar.gz
