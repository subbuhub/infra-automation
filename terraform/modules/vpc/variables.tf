
variable "application" {}

variable "environment" {}

variable "vpc_cidr_block" {}

variable "zones" {
  default = {
    zone0 = ""
  }
}

variable "public_cidr_blocks" {
  default = {
    zone0 = ""
  }
}

variable "private_cidr_blocks" {
  default = {
    zone0 = ""
  }
}


