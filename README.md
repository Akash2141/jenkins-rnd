```sh
$ vagrant up jenkins-master jenkins-agent --provision
```

```sh
$ vagrant destroy -f
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