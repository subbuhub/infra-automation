output "web_app_elb_dns_name" {
  value = aws_lb.web_app_elb.dns_name
}

output "web_app_elb_zone_id" {
  value = aws_lb.web_app_elb.zone_id
}

output "web_app_security_group_id" {
  value = aws_security_group.web_app_sg.id
}

output "web_app_node_public_ips" {
  value = data.aws_instances.app_node_data.public_ips
}