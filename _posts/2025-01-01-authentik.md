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

To download the latest docker-compose.yml open your terminal and navigate to the directory of your choice. Run the following command:

```shell
wget https://goauthentik.io/docker-compose.yml
```

If this is a fresh authentik installation, you need to generate a password and a secret key. Use a secure password generator of your choice such as pwgen, or you can use openssl as below.

Run the following commands to generate a password and secret key and write them to your `.env` file:

```shell
echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" >> .env
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
```

To enable error reporting, run the following command:

```shell
echo "AUTHENTIK_ERROR_REPORTING__ENABLED=true" >> .env
```


# Email configuration (optional but recommended)
It is also recommended to configure global email credentials. These are used by authentik to notify you about alerts and configuration issues. They can also be used by Email stages to send verification/recovery emails.

To configure email credentials, append this block to your `.env` file

```text
# SMTP Host Emails are sent to
AUTHENTIK_EMAIL__HOST=localhost
AUTHENTIK_EMAIL__PORT=25
# Optionally authenticate (don't add quotation marks to your password)
AUTHENTIK_EMAIL__USERNAME=
AUTHENTIK_EMAIL__PASSWORD=
# Use StartTLS
AUTHENTIK_EMAIL__USE_TLS=false
# Use SSL
AUTHENTIK_EMAIL__USE_SSL=false
AUTHENTIK_EMAIL__TIMEOUT=10
# Email address authentik will send from, should have a correct @domain
AUTHENTIK_EMAIL__FROM=authentik@localhost
```

```shell
docker-compose up -d
```

There you are prompted to set a password for the akadmin user (the default user).

# Traefik

```yaml
services:
    traefik:
        image: traefik:v3.0
        container_name: traefik
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
        ports:
            - 80:80
        command:
            - "--api"
            - "--providers.docker=true"
            - "--providers.docker.exposedByDefault=false"
            - "--entrypoints.web.address=:80"

    authentik-proxy:
        image: ghcr.io/goauthentik/proxy
        ports:
            - 9000:9000
            - 9443:9443
        environment:
            AUTHENTIK_HOST: https://your-authentik.tld
            AUTHENTIK_INSECURE: "false"
            AUTHENTIK_TOKEN: token-generated-by-authentik
            # Starting with 2021.9, you can optionally set this too
            # when authentik_host for internal communication doesn't match the public URL
            # AUTHENTIK_HOST_BROWSER: https://external-domain.tld
        labels:
            traefik.enable: true
            traefik.port: 9000
            traefik.http.routers.authentik.rule: Host(`app.company`) && PathPrefix(`/outpost.goauthentik.io/`)
            # `authentik-proxy` refers to the service name in the compose file.
            traefik.http.middlewares.authentik.forwardauth.address: http://authentik-proxy:9000/outpost.goauthentik.io/auth/traefik
            traefik.http.middlewares.authentik.forwardauth.trustForwardHeader: true
            traefik.http.middlewares.authentik.forwardauth.authResponseHeaders: X-authentik-username,X-authentik-groups,X-authentik-entitlements,X-authentik-email,X-authentik-name,X-authentik-uid,X-authentik-jwt,X-authentik-meta-jwks,X-authentik-meta-outpost,X-authentik-meta-provider,X-authentik-meta-app,X-authentik-meta-version
        restart: unless-stopped

    whoami:
        image: containous/whoami
        labels:
            traefik.enable: true
            traefik.http.routers.whoami.rule: Host(`app.company`)
            traefik.http.routers.whoami.middlewares: authentik@docker
        restart: unless-stopped
```


# Reverse-proxy

Since authentik uses WebSockets to communicate with Outposts, it does not support HTTP/1.0 reverse-proxies. The HTTP/1.0 specification does not officially support WebSockets or protocol upgrades, though some clients may allow it.

If you want to access authentik behind a reverse proxy, there are a few headers that must be passed upstream:

- `X-Forwarded-Proto`: Tells authentik and Proxy Providers if they are being served over an HTTPS connection.
- `X-Forwarded-For`: Without this, authentik will not know the IP addresses of clients.
- `Host`: Required for various security checks, WebSocket handshake, and Outpost and Proxy Provider communication.
- `Connection: Upgrade` and `Upgrade: WebSocket`: Required to upgrade protocols for requests to the WebSocket endpoints under HTTP/1.1.
It is also recommended to use a modern TLS configuration and disable SSL/TLS protocols older than TLS 1.3.

If your reverse proxy isn't accessing authentik from a private IP address, trusted proxy CIDRs configuration needs to be set on the authentik server to allow client IP address detection.

The following nginx configuration can be used as a starting point for your own configuration.

```text
# Upstream where your authentik server is hosted.
upstream authentik {
    server <hostname of your authentik server>:9443;
    # Improve performance by keeping some connections alive.
    keepalive 10;
}

# Upgrade WebSocket if requested, otherwise use keepalive
map $http_upgrade $connection_upgrade_keepalive {
    default upgrade;
    ''      '';
}

server {
    # HTTP server config
    listen 80;
    listen [::]:80;
    server_name sso.domain.tld;
    # 301 redirect to HTTPS
    return 301 https://$host$request_uri;
}
server {
    # HTTPS server config
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name sso.domain.tld;

    # TLS certificates
    ssl_certificate /etc/letsencrypt/live/domain.tld/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.tld/privkey.pem;
    add_header Strict-Transport-Security "max-age=63072000" always;

    # Proxy site
    # Location can be set to a subpath if desired, see documentation linked below:
    # https://goauthentik.io/docs/installation/configuration#authentik_web__path
    location / {
        proxy_pass https://authentik;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade_keepalive;
    }
}
```