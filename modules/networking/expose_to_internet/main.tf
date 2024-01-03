resource "aws_lb" "external" {
name = "external-lb"
internal = false
load_balancer_type = "application"
security_groups = ["sg-xxx"]
subnets = ["subnet-xxx",subnet-xx"]
}

resource "aws_lb_listener" "nginx" {
load_balancer_arn = aws_lb.external.arn
port = 80
protocol = "HTTP"

default_action {
type = "fixed-response"
fixed_response { 
content_type = "text/plain"
status_code = "200"
message_body = "OK"
}
}
}

resource "aws_lb_listener" "grafana" {
load_balancer_arn = aws_lb.external.arn
port = 3000
protocol = "HTTP"

default_action {
type = "fixed-response"
fixed_response { 
content_type = "text/plain"
status_code = "200"
message_body = "OK"
}
}
}

