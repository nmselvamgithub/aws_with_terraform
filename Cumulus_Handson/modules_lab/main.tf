# Terraform plugin
terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "nmstokyovpc" {
  source               = "./modules/VPC"
  vpc_cidr             = local.vpc_cidr
  vpc_tags             = var.vpc_tags
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}

module "webserver" {
  source = "./modules/webserver"

  nms_vpc_id         = module.nmstokyovpc.vpc_id
  nms_public_subnets = module.nmstokyovpc.nms_public_subnets


}

module "db" {
  source = "./modules/db"

  nms_vpc_id               = module.nmstokyovpc.vpc_id
  nms_private_subnets      = module.nmstokyovpc.nms_public_subnets
  nms_private_subnet_cidr = local.private_subnet_cidrs

  db_az            = local.availability_zones[0]
  db_name          = "nmsRDS"
  db_user_name     = var.db_user_name
  db_user_password = var.db_user_password
}