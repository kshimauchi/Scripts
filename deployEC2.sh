#!/bin/bash
# send script output to /temp so we can debut boot failures
exec > /tmp/userdata.log 2>&1
# update all packages
yum -y update
# Get latest cfn scripts; https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html#cfninit
yum install -y aws-cfn-bootstrap

# preparing ec2 host machine
cat >   /tmp/install_script.sh << EOF
        echo "Setting up NodeJS"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        ./home/ec2-user/.nvm/nvm.sh
        ./home/ec2-user/.bashrc
    # Install NVM, NPM, Node.js
        nvm alias default v16.20.0
        nvm install v16.20.0
        nvm use v16.20.0
    # Install git
        sudo yum install -y git

    # install docker 
      sudo amazon-linux-extras install docker
      sudo service docker start
      sudo usermod -a -G docker ec2-user
      sudo chkconfig docker on
      sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose      
      sudo reboot      
      # Create log directory
      mkdir -p /home/ec2-user/app/logs  

EOF

#
# How to use the script?
# head over to AWS and launch an ec2 instance (e.g. Amazon Linux 2 )
# Go to the UserData section of the ec2 instance setup
# copy and paste everything contained in ec2-server-script.sh into the UserData section
# launch your ec2 instance
# Once your ec2 instance is launched, you can ssh into your server and check if docker and docker-compose have been installed. You can do this by running:

# docker version
# docker-compose version
#