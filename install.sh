#!/bin/bash

# Update System
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs

# Install Build Tools
echo "Installing build-essential..."
sudo apt install -y build-essential

# Install PM2
echo "Installing PM2..."
sudo npm install pm2@latest -g

# Install MongoDB
echo "Installing MongoDB..."
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org

# Start and Enable MongoDB
echo "Starting MongoDB..."
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Enable Firewall
echo "Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

# Done
echo "Installation complete!"
