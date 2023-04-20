provider "aws" {
  region     = "us-east-1"
}

# 9. Create Ubuntu server and install/enable apache2.


resource "aws_instance" "apache2-first" {
   ami           = "ami-016eb5d644c333ccbf"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "project"
    
   
}
