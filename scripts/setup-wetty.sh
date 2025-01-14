#!/usr/bin/env bash

DNS_FILE="/tmp/dns.txt"
DOCKER_COMPOSE_FILE="/tmp/scripts/wetty.docker-compose.yaml"

if [ -f $DNS_FILE ]; then
  if ! grep -q "none" $DNS_FILE; then
    HOST_ADDR=$(cat $DNS_FILE)
    export HOST_ADDR
    echo "HOSTNAME set to: $DNS_ADDR"
  else
    HOST_ADDR=$(hostname -I | awk '{print $1}')
    echo "$DNS_FILE contains 'none', DNS_ADDR not set. HOSTNAME set to $HOST_ADDR"
  fi
else
  echo "$DNS_FILE does not exist"
fi

sed -i "s/<hostname>/$HOST_ADDR/g" "$DOCKER_COMPOSE_FILE"

sudo docker compose -f $DOCKER_COMPOSE_FILE up -d
