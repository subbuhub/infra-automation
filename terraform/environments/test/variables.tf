# AWS Account ID
variable "aws_account_id" {
  default = "xxxxxxxxxxxxxxx"
}

# SSH public key for web application server
variable "ssh_public_key" {
  default = "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

# AMI image ID created in packer section
variable "ami" {
  default = "ami-xxxxxxxxxxxxx"
}

# IP address to allow SSH into web application server
variable "app_server_ssh_whitelist_ips" {
  default = ["xx.xx.xx.xx/32"]
}

variable "region" {
default = "us-west-2"
}

variable "application" {
default = "web-app"
}

variable "environment" {
default = "test"
}

variable "zones" {
default = {
zone0 = "us-west-2a"
zone1 = "us-west-2b"
}
}

variable "vpc_cidr_block" {
default = "10.20.0.0/16"
}

variable "public_cidr_blocks" {
  default = {
    zone0 = "10.20.20.0/24"
    zone1 = "10.20.40.0/24"
  }
}

variable "private_cidr_blocks" {
  default = {
    zone0 = "10.20.10.0/24"
    zone1 = "10.20.30.0/24"
  }
}

variable "web_app_elb_whitelist" {
  default = [
    "0.0.0.0/0"
  ]
}

variable "web_app" {
  default = {
    instance_type = "t2.small"
    volume_type = "gp2"
    volume_size = 20
    asg_desired_capacity = 1
    asg_max_size  = 2
    asg_min_size  = 1
    multi_az      = false
    docker_image  = "csmanyam/nodejs:web-app-1.0.0"
  }
}


