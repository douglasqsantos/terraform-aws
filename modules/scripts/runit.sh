#!/bin/bash

## Upgrading the system
sudo apt update
sudo apt upgrade -y

## Java Installation
sudo apt install ca-certificates -y
sudo apt install openjdk-11-jdk -y

## Jenkins Installation
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y

## Nginx Installation
sudo apt-get update
sudo apt-get install nginx -y

## Nginx Disable default site
unlink /etc/nginx/sites-enabled/default

## Creating Jenkins Site
cat << EOF > /etc/nginx/conf.d/jenkins.conf
# /etc/nginx/conf.d/jenkins.conf
upstream jenkins {
  server 127.0.0.1:8080;
}

server {
  listen 80 default;
  #server_name your_jenkins_site.com;#
  access_log /var/log/nginx/jenkins.access.log;
  error_log /var/log/nginx/jenkins.error.log;
  proxy_buffers 16 64k;
  proxy_buffer_size 128k;

  location / {
    proxy_pass http://jenkins;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
    proxy_redirect off;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto http;
  }
}
EOF

## Restarting Nginx Server
systemctl restart nginx