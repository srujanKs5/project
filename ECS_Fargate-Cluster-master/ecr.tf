resource "aws_ecr_repository" "service-1" {
  name = format("%s-%s-int-service-1-ecr",var.dns_name, var.account_environment)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
