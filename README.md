# Skool MVP Infra

Built by **Hector Curi** as a personal project to demonstrate end-to-end DevOps/SRE skills (Terraform, AWS, Kubernetes, GitOps).

Terraform configuration that provisions AWS VPC, networking (public/private subnets, IGW, NAT), EKS cluster, RDS Postgres, and AWS-native ingress prerequisites (ACM + IRSA) for the Skool MVP system.

## Architecture / Project structure
- `modules/vpc` – VPC, public/private subnets across 2 AZs, IGW, NAT, route tables.
- `modules/eks` – EKS control plane, managed node group, IAM roles + OIDC provider (IRSA).
- `modules/rds` – RDS Postgres in private subnets, security group restricted to EKS.
- `environments/dev` – Wires modules together and also provisions:
  - ACM wildcard cert (`skoo1.com` + `*.skoo1.com`) in `us-west-2` for ALB TLS termination.
  - IAM role/policy for AWS Load Balancer Controller (IRSA).
  - Subnet tags required for ALB discovery.

## How this fits into the Skool MVP
- This repo stands up the AWS environment (VPC, EKS, RDS) and AWS-native ingress prerequisites used by the Skool MVP API and web frontend.
- API code + Helm chart live in `skool-mvp-api` (https://github.com/hcuri/skool-mvp-api).
- GitOps/ArgoCD config lives in `skool-mvp-gitops` (https://github.com/hcuri/skool-mvp-gitops).

## Usage
```bash
cd environments/dev
AWS_PROFILE=skool terraform init
AWS_PROFILE=skool terraform plan
AWS_PROFILE=skool terraform apply
```
- Region defaults to `us-west-2` via `aws_region` variable.
- Credentials via AWS CLI/profile (`aws login --profile signin` then `AWS_PROFILE=skool`), not hard-coded keys.
- Cluster access after apply:
  ```bash
  aws eks update-kubeconfig --name skool-mvp-dev-eks --region us-west-2 --profile skool
  kubectl get nodes
  ```

## DNS / certificates (Cloudflare)
This demo uses Cloudflare DNS as the authoritative DNS provider (Cloudflare Registrar).

- Terraform requests an ACM certificate and outputs the required DNS validation CNAME records.
- Create those CNAME records manually in Cloudflare as **DNS-only** (grey cloud) to get the cert to Issued.
- After the ALB exists (created by AWS Load Balancer Controller), point `api.skoo1.com`, `grafana.skoo1.com`, and `web.skoo1.com` at the ALB using Cloudflare **DNS-only** records so TLS terminates at the ALB using ACM.

## Security / secrets
- DB passwords and other sensitive values are passed via `terraform.tfvars` or `TF_VAR_db_password`; they are not committed.
- For production-grade setups, store DB creds in AWS Secrets Manager and surface them to apps via an operator/External Secrets.
- State is local by default; add S3+Dynamo remote state for team use.
