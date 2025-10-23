# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
JENKINS_USER = "jenkins"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Global provider configuration
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    vb.name = "Jenkins_Master_Slave_Setup"
  end

  # --- Jenkins Master VM Configuration ---
  config.vm.define "jenkins-master" do |master|
    master.vm.box = "ubuntu/jammy64"
    master.vm.hostname = "jenkins-master"
    
    # Port Forwarding: Jenkins UI (8080) and Jenkins SSH (Optional, but useful for CLI/Groovy)
    master.vm.network "forwarded_port", guest: 8080, host: 8080, id: "jenkins_web"
    
    # Private network for communication with agent
    master.vm.network "private_network", ip: "192.168.56.10"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    end
    
    # Shell provisioning to install Jenkins and required tools
    # master.vm.provision "shell", path: "provision-master.sh"
    
    # **Critical Automation Step:** Execute a Groovy script to configure Jenkins
    # master.vm.provision "shell", inline: <<-SHELL
    #   # Wait for Jenkins to start up before running the Groovy script
    #   until curl -s http://127.0.0.1:8080/cli/ > /dev/null; do sleep 5; done
      
    #   echo "Jenkins is running."

    #   # 2. Download the jenkins-cli.jar to the current user's home directory (vagrant)
    #   echo "Downloading jenkins-cli.jar..."
    #   wget -O /home/vagrant/jenkins-cli.jar http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar
    #   JENKINS_INIT_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
    #   echo "export JENKINS_INIT_PASSWORD=$JENKINS_INIT_PASSWORD" | sudo tee /etc/profile.d/jenkins_vars.sh > /dev/null

    #   echo "Installing required plugins for SSH and Credentials..."
    #   sudo /usr/bin/java -jar /home/vagrant/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$JENKINS_INIT_PASSWORD install-plugin credentials ssh-credentials ssh-slaves git
      
    #   echo "Restarting Jenkins to apply new plugins..."
    #   sudo /usr/bin/java -jar /home/vagrant/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$JENKINS_INIT_PASSWORD safe-restart
      
    #   echo "Waiting for Jenkins to be fully back online (checking HTTP 200 status)..."
    #   MAX_RETRIES=12  # Check for 1 minute (12 * 5 seconds)
    #   RETRY_COUNT=0
    #   until [ $RETRY_COUNT -ge $MAX_RETRIES ]; do
    #       STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/login)
          
    #       if [ "$STATUS_CODE" -eq 200 ]; then
    #           echo "Jenkins is fully operational (HTTP 200). Proceeding."
    #           break
    #       fi

    #       echo "Status: $STATUS_CODE. Still waiting..."
    #       RETRY_COUNT=$((RETRY_COUNT + 1))
    #       sleep 5
    #   done

    #   if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    #       echo "ERROR: Jenkins did not start in time. Aborting setup."
    #       exit 1
    #   fi
      
    #   # 3. Execute the Groovy script using the downloaded jar
    #   echo "Running Groovy script to configure Agent Node..."
    #   /usr/bin/java -jar /home/vagrant/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$JENKINS_INIT_PASSWORD groovy = < /vagrant/configure-agent.groovy
    # SHELL
  end
  
  # --- Jenkins Agent VM Configuration ---
  config.vm.define "jenkins-agent" do |agent|
    agent.vm.box = "ubuntu/jammy64"
    agent.vm.hostname = "jenkins-agent"

    # Private network for master to connect to (Agent IP)
    agent.vm.network "private_network", ip: "192.168.56.20" 
    
    agent.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
    
    # Shell provisioning to install Java, Git, and create the Jenkins user/directories
    # agent.vm.provision "shell", path: "provision-agent.sh"
  end
end