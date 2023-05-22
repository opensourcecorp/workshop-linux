output "instance_ips" {
  value = { for instance in module.team_servers : instance.tags_all["Name"] => instance.public_ip }
}

output "db_pub_ip" {
  value = module.db.public_ip
}

output "db_priv_ip" {
  value = module.db.private_ip
}