
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Define the VPC variable for referencing
data "aws_vpcs" "eks_vpc" {}

# Use count.index to loop through namespaces
resource "aws_subnet" "grafana_lb_subnet" {
  count = length(var.namespaces)

  cidr_block        = "10.0.${count.index + 2}.0/24"
  availability_zone = "us-west-2a"
  vpc_id            = data.aws_vpcs.eks_vpc.ids[count.index]  # Use the VPC IDs

  tags = {
    Name = "grafana-lb-subnet-${count.index + 2}"
  }
}

resource "kubernetes_service" "grafana_service" {
  metadata {
    name      = "grafana"
    namespace = var.namespaces[0]
  }

  spec {
    selector = { app = "grafana" }

    port {
      port        = 3000  # Assuming Grafana uses port 3000
      target_port = 3000
    }
  }
}

# Grafana ALB
resource "aws_lb" "grafana_lb" {
  name               = "grafana-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grafana_lb_sg.id]
  subnets            = aws_subnet.grafana_lb_subnet[*].id
}

# Security Group for Grafana ALB
resource "aws_security_group" "grafana_lb_sg" {
  name        = "grafana-lb-sg"
  description = "Security group for Grafana ALB"

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere (update as needed)
  }
}


# ALB Listener for Grafana
resource "aws_lb_listener" "grafana_lb_listener" {
  load_balancer_arn = aws_lb.grafana_lb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Welcome to Grafana on EKS"
      status_code  = "200"
    }
  }
}

resource "helm_release" "prometheus" {
name = "prometheus"
repository = "https://prometheus-community.github.io/helm-charts"
chart = "prometheus"
namespace = var.namespaces[0]
set{
 name = "server.service.type"
 value = "LoadBalancer"
}
}

resource "helm_release" "grafana" {
name = "grafana"
repository = "https://grafana.github.io/helm-charts"
chart = "grafana"
namespace = var.namespaces[0]
set{
 name = "service.type"
 value = "LoadBalancer"
}
}
