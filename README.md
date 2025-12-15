# Skool MVP Infra

Built by **Hector Curi** as a personal project to demonstrate end-to-end DevOps/SRE skills (Terraform, AWS, Kubernetes, GitOps).

Terraform configuration that provisions AWS VPC, networking (public/private subnets, IGW, NAT), EKS cluster, and RDS Postgres for the Skool MVP app.

## Architecture / Project structure
- `modules/vpc` – VPC, public/private subnets across 2 AZs, IGW, NAT, route tables.
- `modules/eks` – EKS control plane, managed node group, IAM roles.
- `modules/rds` – RDS Postgres in private subnets, security group restricted to EKS.
- `environments/dev` – Wires modules together with region/profile/DB settings for dev.

## How it fits into the Skool MVP
- This repo stands up the AWS environment (VPC, EKS, RDS) used by the Skool MVP API.
- App code + Helm chart live in `skool-mvp-app` (API backend).
- GitOps/ArgoCD config lives in `skool-mvp-gitops`.

## Usage (dev, high level)
```bash
cd environments/dev
AWS_PROFILE=skool terraform init
AWS_PROFILE=skool terraform plan
AWS_PROFILE=skool terraform apply
```
- Region defaults to `us-west-2` via `aws_region` variable.
- Credentials via AWS CLI/profile (`aws login --profile signin` then `AWS_PROFILE=skool`), not hard-coded keys.

## Security / secrets
- DB passwords and other sensitive values are passed via `terraform.tfvars` or `TF_VAR_db_password`; they are not committed.
- For production-grade setups, store DB creds in AWS Secrets Manager and surface them to apps via an operator/External Secrets.
- State is local by default; add S3+Dynamo remote state for team use.

## License & attribution
- Licensed under the MIT License (see `LICENSE`).
- You are welcome to copy/adapt the code. If you reuse it, please preserve the original copyright and license notices so attribution to the author, Hector Curi, is retained.
