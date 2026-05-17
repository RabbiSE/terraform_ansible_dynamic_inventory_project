# key_pair
resource "aws_key_pair" "terraform_ansible_key" {
  key_name   = var.key_name
  public_key = file("terraform_ansible_key.pub")
}

# vpc 
resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "Default VPC"
  }
}

# security group
resource "aws_security_group" "security_group" {
  name        = "security-group"
  description = "Inbound and outbound traffic defination"
  vpc_id      = aws_default_vpc.vpc.id

  # inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "ALL"
  }

  tags = {
    Name = "security-group"
  }
}

# ec2 instance
resource "aws_instance" "vm_instances" {
  for_each = var.instances
  depends_on = [ aws_key_pair.terraform_ansible_key, aws_security_group.security_group ]
  key_name        = aws_key_pair.terraform_ansible_key.key_name
  security_groups = [ aws_security_group.security_group.name ]
  instance_type   = each.value.instance_type
  ami             = each.value.ami

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}