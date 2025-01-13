
data "aws_route53_zone" "root_zone" {
  count = var.create_dns ? 1 : 0
  name  = var.zone_name

}

resource "aws_route53_zone" "workshop_zone" {
  count = var.create_dns ? 1 : 0
  name  = "${var.event_name}.${var.zone_name}"
}

resource "aws_route53_record" "workshop" {
  count   = var.create_dns ? 1 : 0
  zone_id = data.aws_route53_zone.root_zone[0].zone_id
  name    = aws_route53_zone.workshop_zone[0].name
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.workshop_zone[0].name_servers
}

resource "aws_route53_record" "teams" {
  count      = var.create_dns ? var.num_teams : 0
  zone_id    = aws_route53_zone.workshop_zone[0].zone_id
  name       = "team-${count.index + 1}"
  type       = "A"
  ttl        = 300 #5 mins
  records    = [module.team_servers[count.index].public_ip]
  depends_on = [aws_route53_record.hub]
}

resource "aws_route53_record" "db" {
  count   = var.create_dns ? 1 : 0
  zone_id = aws_route53_zone.workshop_zone[0].zone_id
  name    = "db"
  type    = "A"
  ttl     = 300 #5 mins
  records = [module.db.public_ip]
}
