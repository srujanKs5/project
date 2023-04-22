region = "us-east-1"

#Environment information
dns_name = "indigo"
account_environment = "dev"
availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

public_hosted_zone = "Z03840633HHYSQHJYWHJ9"
alb_certificate = "arn:aws:acm:us-east-1:653454134395:certificate/42606954-6e1d-4810-b01c-8129ecb4f6cf"

#node group details
ami_type = "AL2_x86_64"
disk_size = "20"
instance_types = ["t3.medium"]
desired_size = "1"
max_size = "1"
min_size = "1"
