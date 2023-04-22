resource "aws_route53_record" "ecs-dns-record" {
  zone_id = var.public_hosted_zone
  name = "jenkins"
  type = "A"

  alias {
    name = aws_alb.main-ext-lb.dns_name
    zone_id = aws_alb.main-ext-lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ecs-dns-record-nginx" {
  zone_id = var.public_hosted_zone
  name = "nginx"
  type = "A"

  alias {
    name = aws_alb.main-ext-lb.dns_name
    zone_id = aws_alb.main-ext-lb.zone_id
    evaluate_target_health = false
  }
}