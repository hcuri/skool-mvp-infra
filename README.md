# Skool MVP Infra

Terraform repo for AWS foundations: VPC (public/private subnets, NAT/IGW, routing), EKS (cluster + managed node groups), and RDS Postgres in private subnets. Uses environment stacks (starting with `environments/dev`) and reusable modules (`modules/vpc`, `modules/eks`, `modules/rds`).

## Status

- Planning/scaffolding; no Terraform code checked in yet.
- Next: lay down provider wiring and module skeletons, then `environments/dev` stack.
