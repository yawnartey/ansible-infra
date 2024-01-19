#defining the key pair 
resource "aws_key_pair" "ansible-keypair" {
  key_name   = "ansible_keypair"
  public_key = file("~/.ssh/id_rsa.pub")
  tags = {
    Name = "ansible-keypair"
  }
}

#creating your security group
resource "aws_security_group" "ansible-allow-web-traffic" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-allow-web-traffic"
  }
}

#creating master ubuntu instance
resource "aws_instance" "ansible-master" {
  ami               = "ami-0c7217cdde317cfec"
  instance_type     = "m5.large"
  #availability_zone = "us-east-1a"
  count             = 1
  key_name          = aws_key_pair.ansible-keypair.key_name

  tags = {
    Name = "ansible-master"
  }
}

#creating host instances
resource "aws_instance" "ansible-host" {
  ami               = "ami-0c7217cdde317cfec"
  instance_type     = "m5.large"
  #availability_zone = "us-east-1a"
  count             = 3
  key_name          = aws_key_pair.ansible-keypair.key_name

  tags = {
    Name = "ansible-host-${count.index + 1}"
  }
}

