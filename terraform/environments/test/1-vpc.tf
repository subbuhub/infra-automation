module "vpc" {
  source = "./../../modules/vpc"

  application = var.application
  environment = var.environment

  vpc_cidr_block = var.vpc_cidr_block

  zones  = {
    zone0 = var.zones.zone0
    zone1 = var.zones.zone1
  }

  public_cidr_blocks ={
    zone0 = var.public_cidr_blocks.zone0
    zone1 = var.public_cidr_blocks.zone1
  }

  private_cidr_blocks = {
    zone0 = var.private_cidr_blocks.zone0
    zone1 = var.private_cidr_blocks.zone1
  }

}


output "id" {
  value = module.vpc.id
}

output "cidr" {
  value = module.vpc.cidr
}

output "private_subnet" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet" {
  value = module.vpc.public_subnet_ids
}

output "eip" {
  value = module.vpc.eip
}

output "gateway_id" {
  value = module.vpc.gateway_id
}

output "nat_id" {
  value = module.vpc.nat_id
}

output "nat_public_ip" {
  value = module.vpc.nat_public_ips
}

output "route_table_public_ID" {
  value = module.vpc.route_table_public_ID
}

output "route_table_private_ID" {
  value = (module.vpc.route_table_private_ID)
}

output "aws_route_table_association_private" {
  value = module.vpc.aws_route_table_association_private
}

output "aws_route_table_association_public" {
  value = module.vpc.aws_route_table_association_public
}