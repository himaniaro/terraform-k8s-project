resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = "nginx"
    namespace = var.namespaces[0]
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx"
    namespace = var.namespaces[0]
  }
  spec {
    selector = kubernetes_deployment.nginx_deployment.metadata[0].labels
    port {
      target_port = 80
      port        = 80
    }
  }
}
resource "aws_lb" "nginx_lb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nginx_lb_sg.id]
  subnets            = aws_subnet.nginx_lb_subnet[*].id
}


resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}
resource "aws_security_group" "nginx_lb_sg" {
  name        = "nginx-lb-sg"
  description = "Security group for nginx ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "nginx_lb_subnet" {
  count             = length(var.namespaces)
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = "us-west-2a"
  vpc_id            = aws_vpc.eks_vpc.id
  tags = {
    name = "nginx-lb-subnet-${count.index + 1}"
  }
}


resource "aws_lb_listener" "nginx_lb_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}
