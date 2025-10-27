```sh
$ vagrant up jenkins-master jenkins-agent --provision
```

```sh
$ vagrant destroy -f
```

```sh
$ vagrant halt
```

```sh
$ vagrant reload
```

```sh
# -t rsa: specifies the RSA algorithm
# -b 4096: specifies a strong key size of 4096 bits
# -f ~/.ssh/my_new_key: specifies the filename for the keys
# -N "": provides an empty passphrase for non-interactive use
ssh-keygen -t rsa -b 4096 -f ~/.ssh/my_new_key -N ""
```

This command creates two files:
- ~/.ssh/my_new_key (Your private key)
- ~/.ssh/my_new_key.pub (Your public key)

```sh
$ cat ~/.ssh/my_new_key.pub
```

output
```txt
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC...a-very-long-string... user@hostname
```

- Part 1 (Type): ssh-rsa
- Part 2 (Key Data): AAAAB3N...
- Part 3 (Comment): user@hostname


Put it into authorized_keys: You can now take the contents of that .pub file and add it to the ~/.ssh/authorized_keys file on the remote server you want to connect to.
```sh
$ cat ~/.ssh/my_new_key.pub >> ~/.ssh/authorized_keys
```

```sh
# The -i flag points directly to your inventory file
ansible jenkins-master -m ping -i /home/vagrant/ansible/hosts.ini
```

Channel 2: Jenkins Operation (jenkins-master -> jenkins-agent-1)
This channel is used by the Jenkins master after it's been set up to connect to the agent and run jobs. This is completely separate from Ansible's communication.

Who is connecting? The jenkins user on the jenkins-master VM.
What does it need? A private key.
Where should this private key be? The perfect location is the jenkins user's home directory, which is /var/lib/jenkins/.ssh/id_rsa on the jenkins-master VM. Your provision-master.sh script already creates this key correctly.
What does the target (jenkins-agent-1) need? The corresponding public key (from /var/lib/jenkins/.ssh/id_rsa.pub) must be placed in the authorized_keys file of the user Jenkins will log in as on the agent. In your setup, this is the jenkins user, so the file is /home/jenkins/.ssh/authorized_keys on the jenkins-agent-1 VM.

For Jenkins: You would ssh-keygen on the jenkins-master VM as the jenkins user. Then you would copy the contents of /var/lib/jenkins/.ssh/id_rsa.pub from jenkins-master into the /home/jenkins/.ssh/authorized_keys file on jenkins-agent-1.

## Halt VM
```sh
$ vagrant halt
```

## Again start Halted VM
```sh
$ vagrant up
```

## Fix for world writable directory
If Ansible were to load ansible.cfg from a world-writable current working directory, it would create a serious security risk. So need to set up *ANSIBLE_CONFIG* variable before running. read more about it in https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir

Example to run ansible ping command
```sh
$ ANSIBLE_CONFIG=./ansible.cfg ansible jenkins-agent-1 -m ping
```


## Ini Example
```ini
jenkins-master ansible_host=192.168.56.10 ansible_port=22 ansible_user=vagrant ansible_private_key_file=~/.ssh/jenkins
jenkins-agent-1 ansible_host=192.168.56.20 ansible_port=22 ansible_user=vagrant ansible_private_key_file=~/.ssh/jenkins

[jenkins-master]
jenkins-master

[jenkins-agent-1]
jenkins-agent-1

[all:children]
jenkins-master
jenkins-agent-1
```

```sh
$ ANSIBLE_CONFIG=./ansible.cfg ANSIBLE_COLLECTIONS_PATH=/usr/local/share/ansible/collections ansible-playbook site.yaml --extra-vars "jenkins_master_ip=192.168.56.10"
```

# Also run specific play with the help of tag
```sh
$ ANSIBLE_CONFIG=./ansible.cfg ANSIBLE_COLLECTIONS_PATH=/usr/local/share/ansible/collections ansible-playbook site.yaml --extra-vars "jenkins_master_ip=192.168.56.10" --tags connect_agent
```

# confirm the module installation
```sh
$ ansible-doc -s community.general.jenkins_credential
```

# Set the target path for the module installation
```sh
$ TARGET_PATH=/usr/local/share/ansible/collections
$ sudo mkdir -p $TARGET_PATH
$ sudo ansible-galaxy collection install community.general --collections-path $TARGET_PATH --force
```

# Ansible Command to configure Second VM
```ini
# Inside your hosts.ini file

[vm_b_group]
VM_B_Hostname ansible_host=VM_B_IP

[vm_b_group:vars]
# Configure a proxy for this group only
ansible_ssh_common_args = '-o ProxyCommand="ssh -W %h:%p -q user_on_a@VM_A_IP"'
```

# SSH Tunnel to Direct SSH into Second VM
```config
# Configuration for the Jump Host (VM A)
Host vm-a
  HostName        VM_A_IP_ADDRESS  # e.g., 192.168.56.5
  User            vagrant          # Or the user you log into VM A with
  # Ensure the key for VM A is available (Vagrant handles this typically)

# Configuration for the Target Host (VM B)
Host vm-b
  HostName        VM_B_IP_ADDRESS  # e.g., 192.168.56.20
  User            vagrant          # Or the user you log into VM B with
  # 🟢 The Magic Line: Use VM A as the Proxy/Jump Host
  ProxyJump       vm-a
  IdentityFile    ~/.ssh/id_rsa    # Ensure the key for VM B is available
```

```sh
$ ssh vm-b
```