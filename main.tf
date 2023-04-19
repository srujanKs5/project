provider "aws" {
  region     = "us-east-1"
}


resource "tls_private_key" "tlsauth" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "auth" {
  key_name   = "auth-key"
  public_key = "tls_private_key.tlsauth.public_key_openssh"
  tags = {
    Name = "auth-key"
  }
  provisioner "file" {
    content     = "aws_key_pair.auth.public_key"
    destination = "/root/keys"
  }
}


#1  Creating vpc 

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "prod-vpc"
  }
}



# 2 Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first-vpc.id

  tags = {
    Name = "internet-prod"
  }
}


# 3 custom  Route table...
resource "aws_route_table" "first-route-table" {
  vpc_id = aws_vpc.first-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod"
  }
}


#4 creating subnet

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet1"
  }
}


# 5. Associate subnet with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.first-route-table.id
}


# 6. Creatind security group to allow Route table

resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.first-vpc.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}


# 7. creating a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-sever-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]
}


# 8. Assign an elastic IP to the network interace created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-sever-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]

}



# 9. Create Ubuntu server and install/enable apache2.


resource "aws_instance" "apache2-first" {
   ami           = "ami-016eb5d644c333ccbf"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "auth-key"
    
    
    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.web-sever-nic.id
    }

}
