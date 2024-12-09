#!/usr/bin/env bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

IP=$(hostname -I | awk '{print $1}')

docker run --rm -d -p 3000:3000 wettyoss/wetty --ssh-host=$IP --title "DevUp Demo" --ssh-port=2332
