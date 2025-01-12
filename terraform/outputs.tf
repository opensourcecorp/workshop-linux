output "instance_ips" {
  value = { for instance in module.team_servers : instance.tags_all["Name"] => instance.public_ip }
}

output "instance_dns" {
  value = { for dns in aws_route53_record.teams : "${dns.name}.${aws_route53_zone.workshop_zone[0].name}" => dns.records }
}

output "db_pub_ip" {
  value = module.db.public_ip
}

output "db_pub_endpoint" {
  value = "http://${module.db.public_ip}:8080"
}

output "db_priv_ip" {
  value = module.db.private_ip
}
