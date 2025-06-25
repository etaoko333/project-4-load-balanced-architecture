variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "eta-oko.com"
}

variable "bucket_name" {
  description = "S3 bucket name for storing website files"
  type        = string
  default     = "tovadel-academy-arr-bucket-123456"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "tovadel-academy"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}