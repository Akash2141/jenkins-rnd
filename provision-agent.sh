#!/bin/bash

JENKINS_USER="jenkins"

# 1. Install Java, Git, and create user
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk git
sudo useradd -m -s /bin/bash $JENKINS_USER
sudo usermod -aG sudo $JENKINS_USER

# 2. Create remote root directory for Jenkins Agent
sudo mkdir -p /home/$JENKINS_USER/agent-workspace
sudo chown -R $JENKINS_USER:$JENKINS_USER /home/$JENKINS_USER

# 3. Set up SSH for 'jenkins' user to be connected by master
sudo -u $JENKINS_USER mkdir -p /home/$JENKINS_USER/.ssh
# Copy the Master's public key from the shared folder and authorize it
# NOTE: This assumes /vagrant is mounted from the host to both VMs.
# We copy the master's public key from the master VM into a known file on the host (like /vagrant/master_pub_key)
# For simplicity, we directly fetch it over the private network:

# In a live setup, you'd transfer the key. For this Vagrant setup, 
# we rely on Vagrant's default keys to SSH into the master, then fetch the key.
# For simplicity, we'll manually copy the master's pub key into a file in the shared folder, 
# and the agent script will read it. (Assume `master_key.pub` is present)
# A more robust solution involves a shared folder or a passwordless SSH setup.

# Assuming a passwordless key exchange has happened (e.g., using shared folder /vagrant)
# We need to run this command from the master after its key is generated:
# vagrant ssh jenkins-master -c "sudo cat /var/lib/jenkins/.ssh/id_rsa.pub > /vagrant/master_key.pub"
# Then, the agent runs:
if [ -f /vagrant/master_key.pub ]; then
  sudo cat /vagrant/master_key.pub | sudo -u $JENKINS_USER tee -a /home/$JENKINS_USER/.ssh/authorized_keys
  sudo chmod 600 /home/$JENKINS_USER/.ssh/authorized_keys
  sudo chown -R $JENKINS_USER:$JENKINS_USER /home/$JENKINS_USER/.ssh
  echo "Master's public key authorized."
else
  echo "WARNING: master_key.pub not found. Manual SSH setup may be required."
fi