variable "cluster_name" {}

variable "namespaces" {
 type = list(string)
 default = []
}

resource "aws_eks_cluster" "eks" {
 name = var.cluster_name
 role.arn = aws_iam_role.eks.arn
 vpc_config { 
 }
}

resource "aws_eks_node_group" "node_group" {
cluster_name = aws_eks_cluster.eks.name
node_group_name = "workers"
node_role_arn = aws_iam_role.eks_nodes.arn
subnet_ids = ["",""]
scaling_config {
}
}

resource "aws_iam_role" "eks" {
}
resource "aws_iam_role" "eks_nodes" {
}

