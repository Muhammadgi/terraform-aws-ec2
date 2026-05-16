provider "aws"  {

  region = "us-west-2"

}

# Key Pair

resource "aws_key_pair" "deployer" {

  key_name   = "deployer-key"

  public_key = "ssh-ed25519 AAdasfjdskfjsdkfjdas3KSJDFASJKDFJSDAKHFJAHFKLASDFJKKJF TEST-SERVER-GS$"

}

# Default VPC

resource "aws_default_vpc" "default" {

  tags = {

    Name = "Default VPC"

  }

}

# Security Group

resource "aws_security_group" "web_sg" {

  name        = "web-security-group"

  description = "Allow SSH and HTTP access"

  vpc_id      = aws_default_vpc.default.id

  ingress {

    description = "SSH Access"

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTP Access"

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    description = "Allow All Outbound Traffic"

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "Web Security Group"

  }

}

# EC2 Instance

# EC2 Instance

resource "aws_instance" "web_server" {

  ami           = "ami-0d13e2317a7e75c95"
  instance_type = "t3.micro"

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "Terraform-Web-Server"
  }
}




