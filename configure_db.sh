#!/bin/bash

# Ask the user for the required data
read -p "Enter the domain name: " DOMAIN_NAME
read -p "Enter the database name: " DB_NAME
read -p "Enter the database username: " DB_USER
read -s -p "Enter the database password: " DB_PASS

# Configure the database
mysql -u root -p -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"

# Configure Mattermost
cp /opt/mattermost/config/config.json /opt/mattermost/config/config.json.bak
jq ".ServiceSettings.SiteURL = \"https://$DOMAIN_NAME\"" /opt/mattermost/config/config.json.bak > /opt/mattermost/config/config.json
jq ".SqlSettings.DataSource = \"mysql://$DB_USER:$DB_PASS@localhost:3306/$DB_NAME?charset=utf8mb4,utf8\"" /opt/mattermost/config/config.json > /opt/mattermost/config/config.json.tmp
mv /opt/mattermost/config/config.json.tmp /opt/mattermost/config/config.json
