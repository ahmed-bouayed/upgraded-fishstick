---
title: Setting a Static IP on Ubuntu
description: Setting a Static IP on Ubuntu
date: 2024-12-12
categories: Ubuntu
tags: Ubuntu
# image:
#   path: /assets/img/headers/docker.webp
#   lqip: data:image/webp;base64,UklGRrwAAABXRUJQVlA4ILAAAABwBACdASoUAAoAPpE4l0eloyIhMAgAsBIJaACdMoMYA0g5kddfIs20gPwMAAD+8K+678X27+Ifrr4b2cALtbJhFrrvOgavoKqyN2+b/3E/laaTA9E+Sxx60qVn9iyJUwv0y7bFakr0/ikf3Eqc4Pos6Sfj0wTFkbbFomvDbRHU19/n/QgVd1plDblQYRUX2tIljvsutOMMaiHkVPlVF1OND0oa7kjnIl/vJzTCpgAAAA==
#   alt: Docker
---


### Identify your network interface name
```bash
ip addr
```
Look for the active interface, typically named eth0 or ens33.
### Edit the netplan configuration file
```bash
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
```bash
sudo netplan apply
```
### Verify the static IP
```bash
ip addr
```
