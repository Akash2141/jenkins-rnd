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

