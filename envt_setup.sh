#!/bin/bash
eval `ssh-agent`
ssh-add ~/.ssh/jenkins_rsa # change according to name of private key
sudo -u $USER mkdir -p ~/ansible_logs/