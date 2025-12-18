variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use for subnets"
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "EKS cluster name used for Kubernetes subnet tags (required for AWS Load Balancer Controller)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
