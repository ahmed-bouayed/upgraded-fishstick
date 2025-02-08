---
title: title
description: description
published: false
date: 2025-01-01
categories: docker
tags: dns docker  
image:
  path: /assets/img/headers/image.webp
  lqip: data:image/webp;base64,
  alt: image
---



git clone https://github.com/StrangeBeeCorp/docker.git ./thehive-cortex

sudo apt install docker-compose-v2

cd thehive-cortex/testing

bash ./scripts/init.sh

docker compose up -d