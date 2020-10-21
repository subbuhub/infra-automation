
module "web-app" {
  source = "./../../modules/web-app"

  application = var.application
  environment = var.environment

  vpc_id            = module.vpc.id
  public_subnet_ids = module.vpc.public_subnet_ids

  web_app_elb_whitelist = var.web_app_elb_whitelist

  key_pair_name = module.key-pair.key_pair_name

  ami           = var.ami

  web_app       = {
    instance_type = var.web_app.instance_type
    volume_type   = var.web_app.volume_type
    volume_size   = var.web_app.volume_size
    asg_desired_capacity = var.web_app.asg_desired_capacity
    asg_max_size  = var.web_app.asg_max_size
    asg_min_size  = var.web_app.asg_min_size
    multi_az      = var.web_app.multi_az
    docker_image  = var.web_app.docker_image
  }

  ssh_whitelist_ips = var.app_server_ssh_whitelist_ips
}

output "web_app_elb_dns_name" {
  value = module.web-app.web_app_elb_dns_name
}

output "web_app_security_group_id" {
  value = module.web-app.web_app_security_group_id
}

output "web_app_node_public_ips" {
  value = module.web-app.web_app_node_public_ips
}


