---
title: Elastic Stack
description: log management, data analytics, and visualization
published: false
date: 2025-01-21
categories:  docker
tags: docker logs ml
image:
  path: /assets/img/headers/elastic.webp
  lqip: data:image/webp;base64,UklGRngAAABXRUJQVlA4IGwAAADQAwCdASoUAAoAPpE4mEeloyKhMAgAsBIJZwDDNCG/GI0QdUHWXIAA/vupQtrYffu+yPH0xSeWGai+NTTTF1Ar3O9sxyvyK4bcCL7YjSfIrpyBu8j2bXE361xr4NWOw+lxG1qwS/gxx7N3AAA=
  alt: elastic
---

install docker
install docker-compose

Increase max_map_count
elasticsearch creates many memory-mapped areas. So you need to set the kernel to give a process at least 262,144 memory-mapped areas.

- Update the `vm.max_map_count` setting in `/etc/sysctl.conf` to set this value permanently.
```bash
vm.max_map_count=262144
```

- To apply the changes, run
```bash
sudo sysctl -p
```

- To verify, run
```bash
sysctl vm.max_map_count
```

```bash
git clone https://github.com/deviantony/docker-elk.git
```

```bash
cd docker-elk
```

```bash
docker compose up setup
```

```bash
docker compose up -d
```


Launch the Kibana web UI by opening http://localhost:5601 in a web browser, and use the following credentials to log in:

user: elastic
password: changeme



The "changeme" password set by default for all aforementioned users is unsecure. For increased security, we will reset the passwords of all aforementioned Elasticsearch users to random secrets.

Reset passwords for default users

The commands below reset the passwords of the elastic, logstash_internal and kibana_system users. Take note of them.

docker compose exec elasticsearch bin/elasticsearch-reset-password --batch --user elastic
docker compose exec elasticsearch bin/elasticsearch-reset-password --batch --user logstash_internal
docker compose exec elasticsearch bin/elasticsearch-reset-password --batch --user kibana_system



Replace usernames and passwords in configuration files

Replace the password of the elastic user inside the .env file with the password generated in the previous step. Its value isn't used by any core component, but extensions use it to connect to Elasticsearch.

Replace the password of the logstash_internal user inside the .env file with the password generated in the previous step. Its value is referenced inside the Logstash pipeline file (logstash/pipeline/logstash.conf).

Replace the password of the kibana_system user inside the .env file with the password generated in the previous step. Its value is referenced inside the Kibana configuration file (kibana/config/kibana.yml).


Restart Logstash and Kibana to re-connect to Elasticsearch using the new passwords

docker compose up -d logstash kibana


## Exposed ports
By default, the stack exposes the following ports

| Name                         | Port    |
| :--------------------------- | ------: |
| Logstash Beats input         | 5044    |
| Logstash TCP input           | 50000   |
| Logstash monitoring API      | 9600    |
| Elasticsearch HTTP           | 9200    |
| Elasticsearch TCP transport  | 9300    |
| Kibana                       | 5601    |