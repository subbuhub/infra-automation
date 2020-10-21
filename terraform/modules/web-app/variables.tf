
variable "application" {}

variable "environment" {}

variable "vpc_id" {}

variable "public_subnet_ids" {}

variable "web_app_elb_whitelist" {}

variable "key_pair_name" {}

variable "ami" {}

variable "web_app" {
  default = {
    instance_type = ""
    volume_type = ""
    volume_size = ""
    asg_desired_capacity = ""
    asg_max_size = ""
    asg_min_size = ""
    multi_az     = ""
    docker_image = ""
  }
}

variable "ssh_whitelist_ips" {}




