num_teams  = 2
event_name = "codemash"
custom_security_group_ingress = [{
  from_port   = 2332,
  to_port     = 2332,
  protocol    = "tcp",
  description = "ssh",
  cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 8080,
    to_port     = 8080,
    protocol    = "tcp",
    description = "http",
    cidr_blocks = "0.0.0.0/0"
  }
  # Wetty config
  , {
    from_port   = 0,
    to_port     = 6556,
    protocol    = "tcp",
    description = "http",
    cidr_blocks = "0.0.0.0/0"
  }
]
zone_name  = "sbx.justindebo.com"
create_dns = true
