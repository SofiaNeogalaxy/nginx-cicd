# Nginx-CICD
Fully automated CICD pipeline to deliver a web-app to staging and production environments using nginx, opensssl, ansible, jenkins, terraform, docker and Amazon EKS

Additional instructions
-----------------------
Assumptions to complete this tutorial:
1. You have an AWS account set up and have an IAM profile with admin permissions setup locally for the AWS CLI.
2. Jenkins setup and basically know how to use it.
3. GitHub's account and Git setup locally with ssh keys.
4. Terraform installed and Terraform Cloud setup.
5. Docker Installed and connected to Docker Hub.
6. Basic knowledge of VPC networking.
7. A key pair generated from the AWS Console.
8. Python3 and pip installed.

Initial setup
-------------

Create a remote repo on GitHub with the same directory name you choose for the cloned repo, then connect to it either using HTTPs or SSH.

- `git clone https://github.com/0xsudo/nginx-devops-project.git`
- `cd nginx-devops-project`
- `git init`
- `git remote add origin https://github.com/<USER>/<REPO>.git #change accordingly`

We will be using the Jenkins user, so we'll need to set up a few things:

1. Add the Jenkins user and set a password, then login as the user.

- `sudo useradd jenkins`
- `sudo passwd jenkins`
- `su jenkins`
2. Create an ssh key pair for our Jenkins user, to be used on GitHub and for connecting to our ec2 instance.
- `ssh-keygen -t rsa`
3. Change ownership to the Jenkins user and group for both .ssh and .aws directories.
- `sudo chown -R jenkins:jenkins ~/.ssh/ ~/.aws/`
4. Move the key pair downloaded from the AWS console into the ssh directory.
- `cp $WORKDIR/<key-pair-name.pem> ~/.ssh/`
5. Create an IAM role in the AWS console and attach it with admin permissions, then use the AWS CLI to it configure locally using the access and secret keys.
- `aws configure`
6. Add our Jenkins user to Docker group and update Docker daemon permissions to allow us to access the socket.
- `sudo usermod -aG docker jenkins`
- `sudo chmod 660 /var/run/docker.sock`
