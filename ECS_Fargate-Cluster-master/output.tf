output "ecs-iam-role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs-cluster" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "web-sg" {
  value = aws_security_group.main-int-service-sg.id
}

output "private-subnet-1" {
  value = aws_subnet.private-subnet-1.id
}

output "private-subnet-2" {
  value = aws_subnet.private-subnet-2.id
}

output "targetgroup-port80" {
  value = aws_alb_target_group.port80-tg-1.arn
}

output "targetgroup-port8080" {
  value = aws_alb_target_group.port8080-tg-2.arn
}

output "targetgroup-port8080-9000" {
  value = aws_alb_target_group.port8080-9000.arn
}
