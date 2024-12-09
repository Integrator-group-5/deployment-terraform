provider "aws" {
  profile = "default"
  region = "us-east-1"
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = "10.0.0.0/16"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.networking.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id                  = module.networking.vpc_id
  public_subnet_ids       = module.networking.public_subnet_ids
  security_group_ids      = [module.security_groups.frontend_sg_id, module.security_groups.backend_sg_id]
  user_data               = file("scripts/clone_and_run.sh")
  key_name                = var.key_name
}
