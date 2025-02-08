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


Docker compose 

docker compose should already be installed on your system. If not, you can manually install it.

As the Docker command becomes more complex, switching to docker compose can be preferable and support automatically restarting on failure or system restart. Create a compose.yml file:

```yaml
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    privileged: true
    ports:
      - 8123:8123
```

Start it by running:
```shell
docker compose up -d
```

Once the Home Assistant Container is running, Home Assistant should be accessible using http://<host>:8123 (replace with the hostname or IP of the system). You can continue with onboarding.


Exposing devices 
In order to use Zigbee or other integrations that require access to devices, you need to map the appropriate device into the container. Ensure the user that is running the container has the correct privileges to access the /dev/tty* file, then add the device mapping to your container instructions:


docker run ... --device /dev/ttyUSB0:/dev/ttyUSB0 ...



Optimizations 
The Home Assistant Container is using an alternative memory allocation library jemalloc for better memory management and Python runtime speedup.

As the jemalloc configuration used can cause issues on certain hardware featuring a page size larger than 4K (like some specific ARM64-based SoCs), it can be disabled by passing the environment variable DISABLE_JEMALLOC with any value, for example:


docker run ... -e "DISABLE_JEMALLOC=true" ...

The error message <jemalloc>: Unsupported system page size is one known indicator.




http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.10.112
    - 192.168.10.0/24
  ip_ban_enabled: true
  login_attempts_threshold: 5
