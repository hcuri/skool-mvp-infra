# Skool MVP Infra

Terraform repo for AWS foundations: VPC (public/private subnets, NAT/IGW, routing), EKS (cluster + managed node groups), and RDS Postgres in private subnets. Uses environment stacks (starting with `environments/dev`) and reusable modules (`modules/vpc`, `modules/eks`, `modules/rds`).

## Status

- Scaffolding in place: provider/versions at repo root, modules for VPC/EKS/RDS, and `environments/dev` wiring them together.
- Next: run `terraform init` / `terraform plan` and review costs/config before any apply.

## Usage (dev)

```bash
cd environments/dev
terraform init
terraform plan
```

> Do **not** run `terraform apply` until costs/credentials/region are confirmed. This will provision real AWS resources (EKS, RDS, NAT).
