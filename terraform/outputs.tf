output "instance_ips" {
  value = { for instance in module.team_servers : instance.tags_all["Name"] => instance.public_ip }
}

output "instance_dns" {
  value = { for dns in aws_route53_record.teams : "${dns.name}.${aws_route53_zone.workshop_zone[0].name}" => dns.records }
}

output "hub_pub_ip" {
  value = module.hub.public_ip
}

output "hub_pub_endpoint" {
  value = "http://${module.hub.public_ip}:8080"
}

output "hub_priv_ip" {
  value = module.hub.private_ip
}
