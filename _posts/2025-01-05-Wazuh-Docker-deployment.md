---
title: wazuh
description: Wazuh Docker deployment
published: true
date: 2025-01-05
categories: security
tags: docker siem wazuh
image:
  path: /assets/img/headers/wazuh.webp
  lqip: data:image/webp;base64,UklGRnYAAABXRUJQVlA4IGoAAACwAwCdASoUAAoAPpE6l0eloyIhMAgAsBIJZACdMoGv/gNpjBiSAADpTyEAWUOwlKDnlVsTZk9ye6gYhuIEMx6/zkQp//LbXgoP+VXEur+W/av/4LT6f5Fcq1+wPXV34bQxK9FD37eFcAAA
  alt: wazuh
---

## What is Wazuh ?

The Wazuh Security Information and Event Management (SIEM) solution is a centralized platform for aggregating and analyzing telemetry in real time for threat detection and compliance. Wazuh collects event data from various sources like endpoints, network devices, cloud workloads, and applications for broader security coverage.

<!-- {: .nolineno }
The diagram below represents a Wazuh deployment architecture. It shows the solution components and how the Wazuh server and the Wazuh indexer nodes can be configured

![](/assets/img/posts/wazuh-architecteur.webp)
*wazuh architecteur* -->

## Requirements

### Container memory

We recommend configuring the Docker host with at least 6 GB of memory. Depending on the deployment and usage, Wazuh indexer memory consumption varies. Therefore, allocate the recommended memory for a complete stack deployment to work properly.

### Increase max_map_count

Wazuh indexer creates many memory-mapped areas. So you need to set the kernel to give a process at least 262,144 memory-mapped areas.

- Update the `vm.max_map_count` setting in `/etc/sysctl.conf` to set this value permanently.

```shell
vm.max_map_count=262144
```

- To apply the changes, run

```shell
sudo sysctl -p
```

- To verify, run

```shell
sysctl vm.max_map_count
```

> If you don’t set the `max_map_count` on your host, the Wazuh indexer will NOT work properly.
> {: .prompt-warning }

### Docker engine

### Docker compose

## Single-node Deployment

1. Clone the Wazuh repository to your system

```shell
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2
```

2. enter into the single-node directory

```shell
cd wazuh-docker/single-node
```

3. Generate self-signed certificates

```shell
docker-compose -f generate-indexer-certs.yml run --rm generator
```

4. Start the Wazuh single-node deployment using docker-compose

```shell
docker-compose up -d
```

The default username and password for the Wazuh dashboard are `admin` and `SecretPassword`.
For [additional security](https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html#change-pwd-existing-usr), you can change the default password for the Wazuh indexer admin user.

## Exposed ports

By default, the stack exposes the following ports

| Name                  |  Port |
| :-------------------- | ----: |
| Wazuh TCP             |  1514 |
| Wazuh TCP             |  1515 |
| Wazuh UDP             |   514 |
| Wazuh API             | 55000 |
| Wazuh indexer HTTPS   |  9200 |
| Wazuh dashboard HTTPS |   443 |
