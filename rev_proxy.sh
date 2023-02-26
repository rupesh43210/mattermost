#!/bin/bash

# Configure nginx as a reverse proxy for Mattermost
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sed -i '/server_name _;/d' /etc/nginx/sites-available/default.bak
cat <<EOT >> /etc/nginx/sites-available/default.bak
server {
    listen 80;
    server_name $DOMAIN_NAME;

    location / {
        client_max_body_size 50M;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Frame-Options SAMEORIGIN;
        proxy_pass http://127.0.0.1:8065;
    }
}
EOT
mv /etc/nginx/sites-available/default.bak
