variable "cluster_name"{
type = string
description = "The name of the EKS cluster"
}

variable "namespaces" {
type = list(string)
default= []
}

variable "cluster_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the EKS cluster"
}
