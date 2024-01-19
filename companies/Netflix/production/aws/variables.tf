variable "region" {
  type        = string
  description = "The AWS region to deploy resources."
  default     = "ap-south-1"
}

variable "cluster_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the EKS cluster"
  default     = "arn:aws:iam::371002684318:role/eks-cluster-role"
}

variable "namespaces" {
  type    = list(string)
  default = []
}
