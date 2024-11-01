## VPC Module
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidr_1 = var.subnet_cidr_1
  subnet_cidr_2 = var.subnet_cidr_2
  az_1         = var.az_1
  az_2         = var.az_2
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# EC2 Module
module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.subnet_id_1
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  frontend_sg_id = module.security_groups.frontend_sg_id
  backend_sg_id  = module.security_groups.backend_sg_id
}


# RDS Module
module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = [module.vpc.subnet_id_1, module.vpc.subnet_id_2]
  backend_subnet_cidr = var.subnet_cidr_1
  secret_name         = var.rds_secret_name
}

# SNS Module
module "sns" {
  source         = "./modules/sns"
  email_endpoint = var.alarm_email
}

# CloudWatch Module
module "cloudwatch" {
  source               = "./modules/cloudwatch"
  frontend_instance_id = module.ec2.frontend_instance_id
  backend_instance_id  = module.ec2.backend_instance_id
  sns_topic_arn        = module.sns.sns_topic_arn
}
