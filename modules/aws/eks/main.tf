variable "cluster_name" {
type=string
description = "The name of the EKS cluster"
}

variable "namespaces" {
 type = list(string)
 default = []
}

resource "aws_iam_role" "eks"{
name="eks-cluster"
assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [{
	Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
      },
    ],
  })
}

# VPC configuration for the EKS cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

# Subnet configuration for the EKS cluster
resource "aws_subnet" "eks_subnet" {
  count = length(var.namespaces)

  cidr_block = "10.0.${count.index + 1}.0/24"
  vpc_id     = aws_vpc.eks_vpc.id
  availability_zone = "us-west-2a"  # Change as needed

  tags = {
    Name = "eks-subnet-${count.index + 1}"
  }
}

# Security Group for the EKS cluster
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.eks_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}


resource "aws_eks_cluster" "eks" {
 name = var.cluster_name
 role.arn = aws_iam_role.eks.arn
 vpc_config { 
subnet_ids = aws_subnet.eks_subnet[*].id
security_groups_ids = [aws_security_group.eks_sg.id]
 }
 depends_on = [aws_vpc.eks_vpc]
}

resource "aws_eks_node_group" "eks_nodes" {
count=length(var.namespaces)

cluster_name = aws_eks_cluster.eks.name
node_group_name = "eks-workers-${count.index + 1}"
node_role_arn = aws_iam_role.eks.arn
subnet_ids = [aws_subnet.eks_subnet[count.index].id]
scaling_config {
desired_size = 2
    max_size     = 3
    min_size     = 1
}
depends_on = [aws_eks_cluster.eks]
}

