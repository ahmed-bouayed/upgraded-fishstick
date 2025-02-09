---
title: authentik
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

```shell
mkdir authentik && cd authentik
```

wget https://goauthentik.io/docker-compose.yml

echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" >> .env
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
echo "AUTHENTIK_ERROR_REPORTING__ENABLED=true" >> .env
echo "COMPOSE_PORT_HTTP=9000" >> .env
echo "COMPOSE_PORT_HTTPS=9443" >> .env




docker compose pull
docker compose up -d



There you are prompted to set a password for the akadmin user (the default user).

For an explanation about what each service in the docker compose file does, [see Architecture](https://docs.goauthentik.io/docs/core/architecture).