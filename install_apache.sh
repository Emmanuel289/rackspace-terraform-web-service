#!/bin/bash

# Update packages and install lamp stack
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

# Install the Apache web server and start the web service.
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Set file permissions for web server
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} +
find /var/www -type f -exec sudo chmod 0664 {} +

# Install stress tool to test scaling policy
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
# Spawn 8 workers spinning on sqrt() with a timeout of 60 seconds
sudo stress --cpu 8 -v --timeout 60s

# Create an index.html file with a welcome message and hostname at /var/www/html/ path
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
