variable "aws_region" {
  description = "AWS region for dev environment"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS CLI/SDK profile to use for credentials"
  type        = string
  default     = "skool"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "skool_mvp"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "skool"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "skool_pass"
}
