#!/bin/bash
sudo chmod 600 /etc/ssh/ssh_host_rsa_key
sudo chmod 600 /etc/ssh/ssh_host_ecdsa_key
sudo chmod 600 /etc/ssh/ssh_host_ed25519_key
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -p 8080:80 nginx