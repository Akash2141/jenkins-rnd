# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # --- Common Settings ---
  config.vm.box = "ubuntu/jammy64"
  config.ssh.insert_key = false # Use Vagrant's default insecure key for all machines
  
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    vb.name = "Jenkins_Ansible_Setup"
  end

  # --- Jenkins Master VM ---
  config.vm.define "jenkins-master" do |master|
    master.vm.hostname = "jenkins-master"
    master.vm.network "forwarded_port", guest: 8080, host: 8080, id: "jenkins_web"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    end
  end

  # --- Jenkins Agent VM (The first slave) ---
  config.vm.define "jenkins-agent-1" do |agent|
    agent.vm.hostname = "jenkins-agent-1"
    agent.vm.network "private_network", ip: "192.168.56.20"
    agent.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "1"
    end
  end
  
  # 💡 Scalability Example: Add jenkins-agent-2 for future testing
  # config.vm.define "jenkins-agent-2" do |agent|
  #   agent.vm.hostname = "jenkins-agent-2"
  #   agent.vm.network "private_network", ip: "192.168.56.21"
  #   agent.vm.provider "virtualbox" do |vb|
  #     vb.memory = "2048"
  #     vb.cpus = "1"
  #   end
  # end

  # --- Ansible Provisioning ---
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/site.yml"
    # Ensure Ansible runs against all VMs defined above
    ansible.limit = "all"
    # Vagrant automatically builds the inventory file (ansible/inventory) for you
    ansible.extra_vars = {
      # Pass the master's IP for agents to use
      jenkins_master_ip: "192.168.56.10" 
    }
  end
end