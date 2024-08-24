#!/bin/bash

# Update the package index
echo "Updating package index..."
sudo apt-get update -y

# Install Java (Jenkins requires Java to run)
echo "Installing Java..."
sudo apt-get install openjdk-17-jdk -y

# Add the Jenkins Debian repository to the system
echo "Adding Jenkins repository..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package index again to include the Jenkins repository
echo "Updating package index again..."
sudo apt-get update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install jenkins -y

# Start and enable Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins
# sudo systemctl enable jenkins

# Display the status of Jenkins service
echo "Checking Jenkins status..."
sudo systemctl status jenkins

# Print the initial admin password for Jenkins
echo "Fetching Jenkins initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Jenkins installation completed successfully!"
echo "You can access Jenkins at http://<your-server-ip>:8080"

sudo apt-get update -y

# Docker Install
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

# Tricy Install

sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

