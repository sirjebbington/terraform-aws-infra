provider "aws" {
  region = "ap-south-1"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "/myapp/${var.environment}/db_password"
}

module "network" {
    source = "../../modules/network"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    availability_zone = var.availability_zone
    environment = var.environment
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  db_port = var.db_port
  environment = var.environment
}

module "bastion" {
  source = "../../modules/bastion"
  ami = var.ami
  instance_type = var.instance_type
  public_subnet_id = module.network.public_subnet_id
  security_group_id = module.security.bastion_sg_id
  key_pair = var.key_pair
  environment = var.environment
}

module "database" {
  source = "../../modules/database"
  db_engine = var.db_engine
  db_instance_class = var.db_instance_class
  storage_size = var.storage_size
  db_name = var.db_name
  db_user = var.db_user
  db_password = data.aws_secretsmanager_secret_version.db_password.secret_string
  private_subnet_id = module.network.private_subnet_id
  security_group_id = module.security.db_sg_id
  environment = var.environment
}