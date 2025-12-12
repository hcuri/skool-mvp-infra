variable "vpc_id" {
  description = "VPC ID for the database"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to Postgres"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "Instance class for the DB"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
