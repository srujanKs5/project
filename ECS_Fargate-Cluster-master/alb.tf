resource "aws_alb" "main-ext-lb" {
  name = format("%s-%s-load-balancer", var.dns_name, var.account_environment)
  internal = false
  load_balancer_type = "application"
  subnets = ["${aws_subnet.public-subnet-1.id}","${aws_subnet.public-subnet-2.id}"]
  security_groups = [
    aws_security_group.main-ext-alb-sg.id
  ]
  tags = {
    Name = format("%s-%s-load-balancer",var.dns_name, var.account_environment) 
  }
}

resource "aws_alb_target_group" "port80-tg-1" {
  name     = format("%s-%s-port80-tg-1",var.dns_name, var.account_environment)
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    path = "/"
    matcher = "200"
  }
  tags = {
    Name = format("%s-%s-port80-tg-1",var.dns_name, var.account_environment) 
  }
}

resource "aws_alb_target_group" "port8080-tg-2" {
  name     = format("%s-%s-port8080-tg-2",var.dns_name, var.account_environment)
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${aws_vpc.main.id}" 

  health_check {
    path = "/"
    matcher = "403"
  }
  tags = {
    Name = format("%s-%s-port8080-tg-2",var.dns_name, var.account_environment)
  }
}




resource "aws_alb_target_group" "port8080-9000" {
  name     = format("%s-%s-port8080-tg-2",var.dns_name, var.account_environment)
  port     = [8080-9000]
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${aws_vpc.main.id}" 

  health_check {
    path = "/"
    matcher = "403"
  }
  tags = {
    Name = format("%s-%s-port8080-tg-2",var.dns_name, var.account_environment)
  }
}






resource "aws_alb_listener" "alb-listener-80" {
  load_balancer_arn = aws_alb.main-ext-lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol = "HTTPS"
      port = "443"
    }
  }
}

resource "aws_alb_listener" "alb-listener-443" {
  load_balancer_arn = aws_alb.main-ext-lb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = var.alb_certificate
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "<html><head><title>404 Not Found</title></head><body><center><h1>404 Not Found</h1></center><hr><center>nginx</center></body></html>"
      status_code = "404"
    }
  }
}


resource "aws_alb_listener_rule" "rule-1" {
  listener_arn = aws_alb_listener.alb-listener-443.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.port8080-tg-2.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
