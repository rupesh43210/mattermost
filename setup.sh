#!/bin/bash

# Ensure all scripts are executable
chmod +x checks.sh mattermost_download.sh configure_db.sh ssl-tls.sh rev_proxy.sh

# Execute prerequisite checks
./checks.sh

# Download and extract Mattermost
./mattermost_download.sh

# Configure Mattermost and database
./configure_db.sh

# Install SSL/TLS certificate
./ssl-tls.sh

# Configure nginx as a reverse proxy for Mattermost
./rev_proxy.sh

# Restart Mattermost and nginx
systemctl restart mattermost
systemctl restart nginx
