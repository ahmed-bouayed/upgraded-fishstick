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
    eth0:  # Replace with your interface name
        dhcp4: no
        addresses:
            - 192.168.1.100/24  # Replace with your desired static IP
        gateway4: 192.168.1.1  # Replace with your gateway
        nameservers:
            addresses:
                - 8.8.8.8  # Replace with your preferred DNS servers
                - 8.8.4.4
```
### Apply the changes
```shell
sudo netplan apply
```
### Verify the static IP
```shell
ip addr
```
