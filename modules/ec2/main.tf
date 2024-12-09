resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = element(var.public_subnet_ids, 0)
  vpc_security_group_ids = var.security_group_ids

  user_data = <<-EOT
#!/bin/bash
# Update system
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Git
sudo yum install git -y

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add /usr/local/bin to PATH
echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile
source /etc/profile

# Cloning deployment-local repository
echo " Cloning 'deployment-local' repository..."
git clone https://github.com/Integrator-group-5/deployment-local.git
cd deployment-local || { echo "Failed to change to 'deployment-local' directory"; exit 1; }

# Make clone_and_run.sh executable
chmod +x clone_and_run.sh || { echo "Failed to make script executable"; exit 1; }
echo "'clone_and_run.sh' script created and made executable."

echo "Executing ./clone_and_run.sh remote"
./clone_and_run.sh remote || { echo "Failed to execute clone_and_run.sh"; exit 1; }
EOT

  tags = {
    Name = "LuxuryWearApp"
  }
}