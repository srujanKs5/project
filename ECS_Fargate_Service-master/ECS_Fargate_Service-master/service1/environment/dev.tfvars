region = "us-east-2"

#Environment information
dns_name = "indigo"
account_environment = "dev"
#################
image_name = "651827679494.dkr.ecr.us-east-2.amazonaws.com/indigo-dev-int-service-1-ecr:latest"
ecs_role = "arn:aws:iam::651827679494:role/indigo-dev-iam-role"
ecs_cluster_id = "indigo-dev-ecs-cluster"
web_sg = "sg-01743769cbf7478e5"
private_subnets = [
"subnet-0a0bd8b6dee0b52cf",
"subnet-0fa007b68c8de0a11"
]
service_tg_arn = "arn:aws:elasticloadbalancing:us-east-2:651827679494:targetgroup/indigo-dev-port8080-tg-2/0d53f2d5c193ad1a"
##########################
task_family_name = "port8080-service","port8081-service"
port = "8080", "8081"
replicas = "1"


