module "key-pair" {
  source = "./../../modules/key-pair"

  application = var.application
  environment = var.environment

  ssh_public_key = var.ssh_public_key

}

output "key_pair_name" {
  value = module.key-pair.key_pair_name
}