---
title: Setting a Static IP on Ubuntu
description: Setting a Static IP on Ubuntu
date: 2024-12-12
categories: Ubuntu
tags: Ubuntu
image:
    path: /assets/img/headers/ubuntu.webp
    lqip: data:image/webp;base64,UklGRoQAAABXRUJQVlA4IHgAAACQAwCdASoUAAoAPpE4l0eloyIhMAgAsBIJQAAK/08+P+l2duJQAP7VF/Lck1P+QHX8j/IL/AnWalGvWeSfomVONXI7gjUOPy/vGETGR/oT42WwhgEi7f+6vpqRlK4GKf/r2uX3k+vSElDqezZjEzqCKl/T3isAAAA=
    alt: ubuntu
---


### Identify your network interface name
```shell
ip addr
```
Look for the active interface, typically named eth0 or ens33.
### Edit the netplan configuration file
```shell
sudo nano /etc/netplan/01-netcfg.yaml
```
Example configuration
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
        addresses:
            - 10.10.10.2/24
        routes:
            - to: default
            via: 10.10.10.1
        nameservers:
            search: [mydomain, otherdomain]
            addresses: [10.10.10.1, 1.1.1.1]
```
### Apply the changes
```shell
sudo netplan apply
```
### Verify the static IP
```shell
ip addr
```
