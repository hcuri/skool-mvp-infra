terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  project_name = "skool-mvp-dev"
  cluster_name = "${local.project_name}-eks"
  tags = {
    Project = local.project_name
    Env     = "dev"
  }
}

module "vpc" {
  source       = "../../modules/vpc"
  vpc_cidr     = var.vpc_cidr
  cluster_name = local.cluster_name
  tags         = local.tags
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = local.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  desired_capacity   = 3
  min_size           = 1
  max_size           = 4
  node_instance_type = "t3.medium"
  tags               = local.tags
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

resource "aws_acm_certificate" "wildcard" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = merge(local.tags, {
    Name = "wildcard-${var.domain_name}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn = aws_acm_certificate.wildcard.arn
  # DNS validation records are created manually in Cloudflare DNS.
  # This resource will remain pending until those records exist and ACM marks the cert as Issued.
  validation_record_fqdns = [
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.resource_record_name
  ]
}

data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "${local.project_name}-aws-load-balancer-controller"
  description = "IAM policy for AWS Load Balancer Controller (EKS)"
  policy      = file("${path.module}/aws-load-balancer-controller-iam-policy.json")

  tags = local.tags
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = "${local.project_name}-aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}
