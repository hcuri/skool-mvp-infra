# Skool MVP Infra

Terraform repo for AWS foundations: VPC (public/private subnets, NAT/IGW, routing), EKS (cluster + managed node groups), and RDS Postgres in private subnets. Uses environment stacks (starting with `environments/dev`) and reusable modules (`modules/vpc`, `modules/eks`, `modules/rds`).

## Status

- Deployed: `environments/dev` applied (VPC + EKS + RDS). Costs reviewed and acceptable for dev.
- Modules: VPC (public/private across 2 AZs + NAT), EKS (cluster + managed node group + IAM), RDS (Postgres, private subnets, SG restricted to EKS).
- Credentials: AWS profile `skool`, region `us-west-2` by default.
- State: local (no remote backend configured).
- DB password: provided via tfvars (not in repo).

## Usage (dev)

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

> Note: This provisions real AWS resources (EKS, NAT, RDS). Keep an eye on ongoing costs and tear down when not needed.

## Notes
- Provider config uses `aws_region` (default `us-west-2`) and `aws_profile` (default `skool`).
- RDS password must be supplied via `terraform.tfvars` (gitignored).
- No remote backend; add S3+Dynamo for team use if needed.
- Cluster access: `aws eks update-kubeconfig --name skool-mvp-dev-eks --region us-west-2 --profile skool`.
