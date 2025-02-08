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



```yaml
services:
  authentik:
    image: ghcr.io/goauthentik/server:latest
    container_name: authentik
    environment:
      - AUTHENTIK_SECRET_KEY=your_secret_key_here
      - AUTHENTIK_DATABASE_URL=postgres://authentik_user:password@postgres/authentik_db
      - AUTHENTIK_HOST=authentik.yourdomain.com  # Replace with your actual domain
    ports:
      - "8000:8000"  # Authentik will run on port 8000 inside the container
    volumes:
      - authentik_data:/var/lib/authentik
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:13
    container_name: authentik_postgres
    environment:
      - POSTGRES_USER=authentik_user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=authentik_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  authentik_data:
  postgres_data:
```