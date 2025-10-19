VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
  config.vm.define "vagrant1" do |vagrant1|
    vagrant1.vm.box = "ubuntu/jammy64"
    vagrant1.vm.network "forwarded_port", guest: 80, host: 8080
    vagrant1.vm.network "forwarded_port", guest: 8080, host: 8081
    vagrant1.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "3"
    end
  end
end