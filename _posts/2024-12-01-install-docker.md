---
title: install docker
description: install docker , docker-compose and run portainer
date: 2024-12-01
categories: docker
tags: docker
image:
  path: /assets/img/commons/Docker-Logo.webp
  lqip: data:image/webp;base64,UklGRg4BAABXRUJQVlA4WAoAAAAQAAAAEwAACgAAQUxQSIkAAAANgJtt2/Hsjm3bScuKC3xLBRN4AauzU6ZLWv62bXWcICImAP9Z9PD6I4XR2zj6+PiejpD0mJ6H0ptl/gmuZkH6Ajm8mpOJswnN+fr5SKK9kYWgnZioFFCzNWJbRjJ+jnwc4f1uPeYz33UuMXPUQpufwYzhlsqij+OXVDJwPsUhcI23CwC4v8b/BABWUDggXgAAAPADAJ0BKhQACwA+kTqYR6WjIqEwCACwEglsAJ0y88IB6/4DyQCwi9gA/gx5/S2u/8Rk3Uq6sPnlFQAqP7GD/J//IV+j8JKqPtz+USzNHuhVLNkLvX+2y18kgF+AAAA=
  alt: Docker
---


## Introduction to Docker

Docker is a powerful platform that allows developers to build, ship, and run applications in containers. These containers are lightweight, portable, and can be deployed consistently across various environments

### 1. Installing Docker
To install Docker on Ubuntu run the following script in your termenal:
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
To verify the installation of Docker, run:
```bash
docker --version
```
>  Adding user to the Docker group
{: .prompt-info }

If you'd like to run Docker without sudo, add your user to the Docker group:
```bash
sudo usermod -aG docker $USER
exec sudo su -l $USER
```

### 2. Installing Docker Compose
Docker Compose is a tool used for defining and managing multi-container Docker applications. To install Docker Compose, run:
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
To verify the installation of Docker Compose, run:
```bash
docker-compose --version
```

### 3. Running Portainer

Portainer is a simple, easy-to-use GUI for managing Docker containers. You can run Portainer as a Docker container by executing the following commands:
```bash
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
After running the above command, you can access Portainer at:
<https://127.0.0.1:9443>


### Troubleshooting
- If you face any issues starting Docker after installation, ensure that the Docker service is running:
```bash
sudo systemctl start docker
```
- To enable Docker to start on boot:
```bash
sudo systemctl enable docker
``` 