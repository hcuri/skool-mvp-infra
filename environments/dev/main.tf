terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  project_name = "skool-mvp-dev"
  tags = {
    Project = local.project_name
    Env     = "dev"
  }
}

module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  tags     = local.tags
}

module "eks" {
  source              = "../../modules/eks"
  cluster_name        = "${local.project_name}-eks"
  private_subnet_ids  = module.vpc.private_subnet_ids
  desired_capacity    = 3
  min_size            = 1
  max_size            = 4
  node_instance_type  = "t3.medium"
  tags                = local.tags
}

module "rds" {
  source                     = "../../modules/rds"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  tags                       = local.tags
}
