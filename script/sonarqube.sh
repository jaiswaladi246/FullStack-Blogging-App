#!/bin/bash

# Update the package index
echo "Updating package index..."
sudo apt-get update -y

# Install Java (Jenkins requires Java to run)
echo "Installing Java..."
sudo apt-get install openjdk-17-jdk -y

sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

sudo docker run -d -p 9000:9000 sonarqube:lts-community