variable "aws_region" {
  description = "AWS region for infrastructure"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "terraform_ansible_key"
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "ssh_key_path" {
  description = "Path to the SSH private key on the Ansible control node"
  type        = string
  default     = "~/keys/terraform-ansible-key"
}

variable "instances" {

  description = "Map of instance names to AMI IDs, SSH users, and OS family"
  
  type = map(object({
    ami       = string
    user      = string
    os_family = string
    instance_type = string
  }))

  # by deafult value to be put in the variable
  default = {
    "control-node-ubuntu" = {
      ami       = "ami-05d62b9bc5a6ca605"
      user      = "ubuntu"
      os_family = "ubuntu"
      instance_type = "t3.medium"
    }
    "worker-ubuntu" = {
      ami       = "ami-05d62b9bc5a6ca605"
      user      = "ubuntu"
      os_family = "ubuntu"
      instance_type = "t3.medium"
    }
    "worker-redhat" = {
      ami       = "ami-0754facaaac92a5bb"
      user      = "ec2-user"
      os_family = "redhat"
      instance_type = "t3.medium"
    }
    "worker-amazon" = {
      ami       = "ami-0b5a4e51202cd98e5"
      user      = "ec2-user"
      os_family = "amazon"
      instance_type = "t3.medium"
    }
  }
}