data "aws_secretsmanager_secret" "rds_secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

resource "aws_db_instance" "mysql_rds" {
  identifier          = "obelion-mysql-database"
  apply_immediately   = true
  allocated_storage   = 8
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = "mydatabase"
  username            = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"]
  password            = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"]
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.Obelio_mysql_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.Obelion-Public-Subnet-Group.name
  multi_az             = false
  skip_final_snapshot  = true

  tags = {
    Name = "Obelion_MySqL_Database"
  }
}

resource "aws_security_group" "Obelio_mysql_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.backend_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "obelion-mysql-sg"
  }
}

resource "aws_db_subnet_group" "Obelion-Public-Subnet-Group" {
  name       = "obelion-public-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Obelion-Public-Subnet-Group"
  }
}
