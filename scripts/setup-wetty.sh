#!/usr/bin/env bash

DNS_FILE="/tmp/dns.txt"
DOCKER_COMPOSE_FILE="/tmp/scripts/wetty.docker-compose.yml"

if [ -f $DNS_FILE ]; then
  if ! grep -q "none" $DNS_FILE; then
    HOSTNAME=$(cat $DNS_FILE)
    export HOSTNAME
    echo "HOSTNAME set to: $DNS_ADDR"
  else
    HOSTNAME=$(hostname -I | awk '{print $1}')
    echo "$DNS_FILE contains 'none', DNS_ADDR not set. HOSTNAME set to $HOSTNAME"
  fi
else
  echo "$DNS_FILE does not exist"
fi

sed -i "s/<hostname>/$HOSTNAME/g" "$DOCKER_COMPOSE_FILE"

sudo docker compose -f $DOCKER_COMPOSE_FILE up -d
