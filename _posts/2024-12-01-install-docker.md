---
title: install docker
description: install docker , docker-compose and run portainer
date: 2024-12-01
categories: docker
tags: docker
image:
  path: /assets/img/headers/docker.webp
  lqip: data:image/webp;base64,UklGRngAAABXRUJQVlA4IGwAAACQAwCdASoUAAsAPpE4mEeloyKhMAgAsBIJYwCdACHesVuBfH9QAP77Las/tl5r7fpWLpn7D2qv6lZyZ3pZPdMJEzzWs6/VbXT4v37Anmc40jKiJ1c/hDTFWrL5tQffgaOmAH14NO7FlHCTgAA=
  alt: Docker
---

### Introduction to Docker

Docker is a powerful platform that allows developers to build, ship, and run applications in containers. These containers are lightweight, portable, and can be deployed consistently across various environments

### Installing Docker

To install Docker on Ubuntu run the following script in your termenal:

```shell
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

```shell
sudo docker --version
```

> Adding user to the Docker group
{: .prompt-info }

If you'd like to run Docker without sudo, add your user to the Docker group:

```shell
sudo usermod -aG docker $USER
su - ${USER}
```

### Installing Docker Compose

Docker Compose is a tool used for defining and managing multi-container Docker applications. To install Docker Compose, run:

```shell
sudo apt install -y docker-compose
```

To verify the installation of Docker Compose, run:

```shell
docker-compose --version
```

### Running Portainer

Portainer is a simple, easy-to-use GUI for managing Docker containers. You can run Portainer as a Docker container by executing the following commands:

```shell
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

After running the above command, you can access Portainer at:
<https://127.0.0.1:9443>

### Troubleshooting

- If you face any issues starting Docker after installation, ensure that the Docker service is running:

```shell
sudo systemctl start docker
```

- To enable Docker to start on boot:

```shell
sudo systemctl enable docker
```
