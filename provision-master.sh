#!/bin/bash

# 1. Install Java and Git
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk git curl wget unzip

# 2. Install Jenkins
# Add Jenkins repo key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

# 3. Wait for Jenkins to be available and create an API Token (needed for the Groovy script)
# For a fully automated setup, the initial admin setup is a major roadblock.
# A common trick for IaaC is to use a pre-installed/configured Jenkins box or bypass this initial setup.
# For simplicity, we assume Jenkins is installed and running here.
# NOTE: In a real scenario, you would automate the unlocking of Jenkins here.

# 4. Generate SSH Key for Jenkins Master User
# This key will be used by Jenkins to connect to the agent
sudo -u jenkins ssh-keygen -t rsa -N "" -f /var/lib/jenkins/.ssh/id_rsa <<< y
# The public key is saved at /var/lib/jenkins/.ssh/id_rsa.pub