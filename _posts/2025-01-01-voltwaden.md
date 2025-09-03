---
title: Vaultwarden 
description: password manager server.
published: true
date: 2025-07-03
categories: security
tags: docker
image:
  path: /assets/img/headers/vaultwarden.webp
  lqip: data:image/webp;base64,UklGRmQAAABXRUJQVlA4IFgAAABwAwCdASoUAAoAPpE4mEeloyKhMAgAsBIJaQAASoUw0PR/SAAA/vra9vsKGFO9u1Vhxb0kHTEbCDyTlrv91cwoSfWx4aVAU3M7Ikt+tCPsyOIGKmjAAAAA
  alt: image
---

Bitwarden is an open-source password manager that helps individuals and teams securely store, manage, and share passwords and sensitive information. It offers end-to-end encryption, cross-platform access, and features like password generation, autofill, and secure sharing.

Vaultwarden is a lightweight, self-hosted alternative to the Bitwarden password manager server. In this post, I'll walk you through deploying Vaultwarden using Docker Compose, including SMTP setup for email notifications.

## Prerequisites

- Docker and Docker Compose installed on your server.
- A domain name pointed to your server (for HTTPS).
- (Optional) An SMTP provider for email notifications.

## Step 1: Prepare the Directory

Create a directory for Vaultwarden and navigate into it:

```sh
mkdir vaultwarden && cd vaultwarden
```

## Step 2: Create `docker-compose.yml`

Below is a sample `docker-compose.yml` file for Vaultwarden:

```yaml
# filepath: docker-compose.yml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    volumes:
      - ./bitwarden:/data:rw
    ports:
      - 8000:80
    environment:
      - ADMIN_TOKEN=${ADMIN_TOKEN}
      - WEBSOCKET_ENABLED=true
      - SIGNUPS_ALLOWED=false
      - DOMAIN=${DOMAIN}
      - SMTP_HOST=${SMTP_HOST}
      - SMTP_FROM=${SMTP_FROM}
      - SMTP_PORT=${SMTP_PORT}
      - SMTP_SECURITY=${SMTP_SECURITY}
      - SMTP_TIMEOUT=${SMTP_TIMEOUT}
      - SMTP_USERNAME=${SMTP_USERNAME}
      - SMTP_PASSWORD=${SMTP_PASSWORD}
```

- `ADMIN_TOKEN`: Used to access the admin interface.
- `WEBSOCKET_ENABLED`: Enables real-time updates.
- `SIGNUPS_ALLOWED`: Set to `true` for initial setup, then `false` to disable public signups.
- `DOMAIN`: Your Vaultwarden instance URL.
- SMTP variables: Configure email notifications.

## Step 3: Create `.env` File

Create a `.env` file in the same directory to store environment variables:

```
# filepath: .env
# General Settings
ADMIN_TOKEN= # Generate with: openssl rand -base64 48
WEBSOCKET_ENABLED=true
SIGNUPS_ALLOWED=true # Set to false after creating your admin account
DOMAIN=https://bitwarden.example.com # Replace with your domain

# SMTP server configuration
SMTP_HOST=smtp-relay.sendinblue.com
SMTP_FROM=user@example.com # Replace with your email
SMTP_TIMEOUT=15
SMTP_USERNAME=user@example.com # SMTP username
SMTP_PASSWORD=yourpassword # SMTP password
SMTP_SECURITY=starttls     # Options: off, force_tls, starttls
SMTP_PORT=587
```

## Step 4: Start Vaultwarden

Run the following command to start Vaultwarden:

```sh
docker compose up -d
```

Vaultwarden will be accessible at `http://your-server-ip:8000` or via your domain if you set up a reverse proxy.

## Step 5: Secure with HTTPS (Recommended)

For production, use a reverse proxy like Nginx or Caddy to enable HTTPS. [Vaultwarden Wiki: Reverse Proxy Examples](https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples)

## Step 6: Access the Admin Interface

Visit `http://your-domain/admin` and enter your `ADMIN_TOKEN` to access the admin panel.

## References

- [Vaultwarden GitHub](https://github.com/dani-garcia/vaultwarden)
- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)

Happy self-hosting!