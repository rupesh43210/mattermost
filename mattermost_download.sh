#!/bin/bash

# Get the latest version of Mattermost
LATEST_VERSION=$(curl -s https://api.github.com/repos/mattermost/mattermost-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

# Download and extract Mattermost
wget https://releases.mattermost.com/$LATEST_VERSION/mattermost-team-$LATEST_VERSION-linux-amd64.tar.gz
tar -xvzf mattermost-team-$LATEST_VERSION-linux-amd64.tar.gz -C /opt/
rm mattermost-team-$LATEST_VERSION-linux-amd64.tar.gz

# Set the required permissions
chown -R mattermost:mattermost /opt/mattermost/
chmod -R g+w /opt/mattermost/
