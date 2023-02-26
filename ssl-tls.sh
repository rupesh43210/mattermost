#!/bin/bash

# Give user options to choose certificate installation method
echo "Choose the SSL/TLS certificate installation method:"
echo "1. Let's Encrypt"
echo "2. Self-signed"
read -p "Enter your choice (1 or 2): " choice

# Install Let's Encrypt certificate
if [ $choice -eq 1 ]; then
  # Install certbot
  apt-get install certbot -y

  # Request a certificate
  certbot certonly --standalone --agree-tos --no-eff-email -d $DOMAIN_NAME -m your-email@example.com

  # Configure nginx with the new certificate
  sed -i 's/listen 80;/listen 80;\n    listen 443 ssl;/g' /etc/nginx/sites-available/default
  sed -i 's/#ssl_certificate/ssl_certificate/g' /etc/nginx/sites-available/default
  sed -i 's/#ssl_certificate_key/ssl_certificate_key/g' /etc/nginx/sites-available/default
  sed -i "s|ssl_certificate .*|ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;|" /etc/nginx/sites-available/default
  sed -i "s|ssl_certificate_key .*|ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;|" /etc/nginx/sites-available/default

# Install self-signed certificate
elif [ $choice -eq 2 ]; then
  # Generate a self-signed certificate
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$DOMAIN_NAME.key -out /etc/ssl/certs/$DOMAIN_NAME.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=$DOMAIN_NAME"

  # Configure nginx with the new certificate
  sed -i 's/listen 80;/listen 80;\n    listen 443 ssl;/g' /etc/nginx/sites-available/default
  sed -i 's/#ssl_certificate/ssl_certificate/g' /etc/nginx/sites-available/default
  sed -i 's/#ssl_certificate_key/ssl_certificate_key/g' /etc/nginx/sites-available/default
  sed -i "s|ssl_certificate .*|ssl_certificate /etc/ssl/certs/$DOMAIN_NAME.crt;|" /etc/nginx/sites-available/default
  sed -i "s|ssl_certificate_key .*|ssl_certificate_key /etc/ssl/private/$DOMAIN_NAME.key;|" /etc/nginx/sites-available/default
else
  echo "Invalid option"
  exit 1
fi

# Test the configuration and restart nginx
nginx -t && systemctl restart nginx
