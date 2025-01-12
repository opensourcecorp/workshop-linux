
data "aws_route53_zone" "name" {
  count = var.zone_name ? 1 : 0
  name  = var.zone_name

}

resource "aws_route53_record" "name" {
  count   = var.zone_name ? var.num_teams : 0
  zone_id = data.aws_route53_zone.name[0].zone_id
  name    = "team-${count.index + 1}"
  type    = "A"
  ttl     = var.ttl
  records = [aws_instance.instance[count.index].public_ip]
}
