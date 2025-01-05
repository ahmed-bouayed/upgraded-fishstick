---
title: wazuh
description: Wazuh Docker deployment
published: True
date: 2025-01-04
categories: siem
tags: docker siem wazuh
image:
  path: /assets/img/headers/wazuh.webp
  lqip: data:image/webp;base64,UklGRnYAAABXRUJQVlA4IGoAAACwAwCdASoUAAoAPpE6l0eloyIhMAgAsBIJZACdMoGv/gNpjBiSAADpTyEAWUOwlKDnlVsTZk9ye6gYhuIEMx6/zkQp//LbXgoP+VXEur+W/av/4LT6f5Fcq1+wPXV34bQxK9FD37eFcAAA
  alt: wazuh
---

![wazuh architecteur](/assets/img/posts/wazuh-architecteur.webp)
```markdown
_wazuh architecteur_
```

## Requirements
### Container memory
We recommend configuring the Docker host with at least 6 GB of memory. Depending on the deployment and usage, Wazuh indexer memory consumption varies. Therefore, allocate the recommended memory for a complete stack deployment to work properly.
### Increase max_map_count
Wazuh indexer creates many memory-mapped areas. So you need to set the kernel to give a process at least 262,144 memory-mapped areas.

- Update the `vm.max_map_count` setting in `/etc/sysctl.conf` to set this value permanently.
```shell
vm.max_map_count=262144 >> /etc/sysctl.conf
```
- To verify after rebooting, run
```shell
sysctl vm.max_map_count
```

> If you don’t set the `max_map_count` on your host, the Wazuh indexer will NOT work properly.
{: .prompt-warning }

### Docker engine
### Docker compose

## Single-node Deployment
1. Clone the Wazuh repository to your system
```shell
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2
```
2.  enter into the single-node directory
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

| Name                         | Port    |
| :--------------------------- | ------: |
| Wazuh TCP                    | 1514    |
| Wazuh TCP                    | 1515    |
| Wazuh UDP                    | 514     |
| Wazuh API                    | 55000   |
| Wazuh indexer HTTPS          | 9200    |
| Wazuh dashboard HTTPS        | 443     |