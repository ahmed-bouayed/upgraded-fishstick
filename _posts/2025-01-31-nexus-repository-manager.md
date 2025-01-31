---
title: Nexus
description: Sonatype Nexus Repository delivers universal support
published: true
date: 2025-01-31
categories: devops
tags: docker devops
image:
  path: /assets/img/headers/nexus.webp
  lqip: data:image/webp;base64,UklGRmYAAABXRUJQVlA4IFoAAAAwAwCdASoUAAoAPpE6l0eloyIhMAgAsBIJZwAAUp2FTq4AAP76yok069Q578M3viWcN4fYOldWqExwoLqwiikshuaFhR8F/YKJGxFbKupDZJh0eiMVogEVqAA=
  alt: Nexus
---

![Nexus](/assets/img/posts/nexus.png)

To deploy Nexus Repository Manager using Docker Compose, you can use the official Sonatype Nexus 3 Docker image. Below is a step-by-step guide and a sample `docker-compose.yaml` file to get you started.

## Create a docker-compose.yaml File

Create a directory `nexus`
```shell
mkdir nexus && cd nexus
```
Create a file named `docker-compose.yaml` with the following content:

```yaml
services:
  nexus:
    image: sonatype/nexus3:latest
    container_name: nexus
    ports:
      - "8081:8081"
    volumes:
      - nexus-data:/nexus-data
    environment:
      - INSTALL4J_ADD_VM_PARAMS=-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m
    restart: unless-stopped

volumes:
  nexus-data:
```

## Start Nexus with Docker Compose
Run the following command in the directory where your `docker-compose.yml` file is located:
```shell
docker-compose up -d
```

## Access Nexus Web UI
Once the container is running, open your browser and navigate to:
<http://localhost:8081>

Default Admin Credentials:
- Username: admin
- Password: Check the admin.password file in the nexus-data volume for the initial password. You can find it by running:
```shell
docker exec -it nexus cat /nexus-data/admin.password
```

## Configure Nexus
1. Log in with the default admin credentials.
2. Change the admin password when prompted.
3. Set up repositories (e.g., Docker, Maven, npm) as needed.
