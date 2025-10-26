# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
JENKINS_USER = "jenkins"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # --- Common Settings ---
  config.vm.box = "ubuntu/jammy64"
  
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  # --- 1. Ansible Control Node VM (Control Host) ---
  config.vm.define "ansible-control" do |control|
    control.vm.hostname = "ansible-control"
    control.vm.network "private_network", ip: "192.168.56.5"
    control.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    end

    control.vm.synced_folder "./ansible", "/home/vagrant/ansible"
    
    # STEP 1: Install Ansible and the community.general collection
    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      # Install python and necessary tools
      sudo apt-get install -y python3-pip git

      # if [ ! -f /home/vagrant/.ssh/jenkins ]; then
      #   ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/jenkins -N ""
      #   cp /home/vagrant/.ssh/jenkins.pub /vagrant/jenkins.pub
      # fi

      
      # Install Ansible and Ansible-Core
      sudo pip3 install ansible
      
      # 🟢 CRITICAL FIX: Install the community.general collection (required for Jenkins modules)
      # Must be run as the 'vagrant' user, not root (sudo), for user-level installation
      sudo -H -u vagrant ansible-galaxy collection install community.general
    SHELL
    
    # Execute Ansible Playbook as the 'vagrant' user
    # 'privileged: false' ensures it runs as 'vagrant', who owns the Ansible collection.
    # control.vm.provision "shell", privileged: false, run: "always", inline: <<-SHELL
    #   MASTER_IP="192.168.56.10"
      
    #   # Execute the playbook using the installed Ansible.
    #   ansible-playbook /home/vagrant/ansible/site.yaml \
    #       --extra-vars "jenkins_master_ip=$MASTER_IP"
          
    #   echo "Ansible execution finished."
    # SHELL
  end

  # --- 2. Jenkins Master VM (Target Host) ---
  config.vm.define "jenkins-master" do |master|
    master.vm.hostname = "jenkins-master"
    master.vm.network "forwarded_port", guest: 8080, host: 8080, id: "jenkins_web"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "3"
    end
    # master.vm.provision "shell", inline: <<-SHELL
    #   ls -la
    #   if [ -f /vagrant/jenkins.pub ]; then
    #     cat /vagrant/jenkins.pub >> /home/vagrant/.ssh/authorized_keys
    #     # Remove duplicates to keep the file clean on re-provisioning
    #     sort -u /home/vagrant/.ssh/authorized_keys -o /home/vagrant/.ssh/authorized_keys
    #   fi
    # SHELL
  end

  # --- 3. Jenkins Agent VM (Target Host) ---
  config.vm.define "jenkins-agent-1" do |agent|
    agent.vm.hostname = "jenkins-agent-1"
    agent.vm.network "private_network", ip: "192.168.56.20"
    agent.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "1"
    end
    # agent.vm.provision "shell", inline: <<-SHELL
    #   if [ -f /vagrant/jenkins.pub ]; then
    #     cat /vagrant/jenkins.pub >> /home/vagrant/.ssh/authorized_keys
    #     # Remove duplicates to keep the file clean on re-provisioning
    #     sort -u /home/vagrant/.ssh/authorized_keys -o /home/vagrant/ssh/authorized_keys
    #   fi
    # SHELL
  end

  # 🔴 REMOVED THE UNRELIABLE ANSIBLE_LOCAL BLOCK 🔴
end
