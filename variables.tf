variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  default     = "my-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "project_id" {
  description = "The ID of your Google Cloud project"
}

variable "credentials_path" {
  description = "The path to your Google Cloud service account credentials JSON file"
}
