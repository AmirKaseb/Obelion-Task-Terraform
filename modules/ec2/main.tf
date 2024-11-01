# Backend instance

resource "aws_instance" "Obelion_backend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.backend_sg_id]

  # Define the user data to install Docker

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              docker --version
              sudo usermod -a -G docker $(whoami)
              sudo chmod 666 /var/run/docker.sock
              newgrp docker
              sudo apt-get install mysql-server -y
              sudo systemctl start mysql
              sudo systemctl enable mysql
              mysql --version
              EOF

  tags = {
    Name = "Obelion_backend_instance"
  }
}

# Frontend instance

resource "aws_instance" "Obelion_frontend_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.frontend_sg_id]

  # Define the user data to install Docker

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              docker --version
              sudo usermod -a -G docker $(whoami)
              sudo chmod 666 /var/run/docker.sock
              newgrp docker
              EOF

  tags = {
    Name = "Obelion_frontend_instance"
  }
}
