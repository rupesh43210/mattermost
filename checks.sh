#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Install required packages
apt-get update
apt-get -y install nginx mariadb-server

# Start the services
systemctl enable nginx
systemctl enable mariadb
systemctl start nginx
systemctl start mariadb
