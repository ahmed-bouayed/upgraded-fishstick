---
title: wazuh
description: Wazuh Docker deployment
published: false
date: 2024-12-01
categories: siem
tags: docker siem wazuh
image:
  path: /assets/img/headers/wazuh.webp
  lqip: data:image/webp;base64,UklGRpwAAABXRUJQVlA4IJAAAADwBACdASoUAAoAPpE4l0eloyIhMAgAsBIJagCdMoRwN6BJgA85aBUuY4SKq3qbOoAA/vDr4cpIt7GnIJvy15A/FTqve38Mf78mI/Rrb0pbMzmr+NzgPXa9yZu+F5OevKVnHu23uJ7irz4JP3T+uvqqDw3c6/MwyQN15dMQnu/6d7/QXUv2fX+gukv6bRPAAAA=
  alt: wazuh
---


![Image description](/assets/img/posts/wazuh-architecteur.webp){:lqip}





```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2
```


```bash
cd wazuh-docker/single-node
```

```bash
docker-compose -f generate-indexer-certs.yml run --rm generator
```

```bash
docker-compose up -d
```