---
title: title
description: description
published: false
date: 2025-01-01
categories: docker
tags: dns docker
image:
  path: /assets/img/headers/image.webp
  lqip: data:image/webp;base64,
  alt: image
---


Create a directory and navigate to it:
```shell
mkdir thehive-cortex && cd thehive-cortex
```

```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:${ELASTICSEARCH_VERSION}
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=${JAVA_OPTS}
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - thehive-cortex-network

  thehive:
    image: strangebee/thehive:${THEHIVE_VERSION}
    container_name: thehive
    depends_on:
      - elasticsearch
      - thehive-postgres
    environment:
      - JAVA_OPTS=${JAVA_OPTS}
      - THEHIVE_DATABASE_DRIVER=postgres
      - THEHIVE_DATABASE_URL=jdbc:postgresql://thehive-postgres:5432/${THEHIVE_POSTGRES_DB}
      - THEHIVE_DATABASE_USER=${THEHIVE_POSTGRES_USER}
      - THEHIVE_DATABASE_PASSWORD=${THEHIVE_POSTGRES_PASSWORD}
      - THEHIVE_ELASTICSEARCH_URL=${ELASTICSEARCH_URL}
    ports:
      - "9000:9000"
    volumes:
      - ./thehive/config:/etc/thehive:ro
      - ./thehive/data/files:/opt/thp/thehive/files
      - ./thehive/logs:/var/log/thehive
    networks:
      - thehive-cortex-network

  cortex:
    image: thehiveproject/cortex:${CORTEX_VERSION}
    container_name: cortex
    depends_on:
      - elasticsearch
    environment:
      - job_directory=/tmp/cortex-jobs
      - docker_job_directory=${cortex_docker_job_directory}
    ports:
      - "9001:9001"
    volumes:
      # Mounting docker socket in the container so that cortex can run jobs as containers
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - thehive-cortex-network

  thehive-postgres:
    image: postgres:${POSTGRES_VERSION}
    container_name: thehive-postgres
    environment:
      - POSTGRES_DB=${THEHIVE_POSTGRES_DB}
      - POSTGRES_USER=${THEHIVE_POSTGRES_USER}
      - POSTGRES_PASSWORD=${THEHIVE_POSTGRES_PASSWORD}
    volumes:
      - thehive_postgres_data:/var/lib/postgresql/data
    networks:
      - thehive-cortex-network

volumes:
  elasticsearch_data:
  thehive_postgres_data:

networks:
  thehive-cortex-network:
```

```text
# TheHive & Cortex Versions
THEHIVE_VERSION=5.4.2-1
CORTEX_VERSION=3.1.8-1

# Database Versions
POSTGRES_VERSION=13-alpine

# Elasticsearch Version
ELASTICSEARCH_VERSION=7.17.24

# Nginx Version (if needed)
NGINX_VERSION=latest

# Database Credentials
THEHIVE_POSTGRES_DB=thehive
THEHIVE_POSTGRES_USER=thehive
THEHIVE_POSTGRES_PASSWORD=thehivepassword

CORTEX_POSTGRES_DB=cortex
CORTEX_POSTGRES_USER=cortex
CORTEX_POSTGRES_PASSWORD=cortexpassword

# Elasticsearch URL
ELASTICSEARCH_URL=http://elasticsearch:9200

# Java Memory Settings
JAVA_OPTS=-Xms1g -Xmx1g

cortex_docker_job_directory=${PWD}/cortex/cortex-jobs
```


```conf
# Sample Cortex application.conf file

## SECRET KEY
#
# The secret key is used to secure cryptographic functions.
#
# IMPORTANT: If you deploy your application to several  instances,  make
# sure to use the same key.
#play.http.secret.key="***CHANGEME***"

## ElasticSearch
search {
  index = cortex
  uri = "http://elasticsearch:9200"
}


cache.job = 10 minutes

auth {
  provider = [local]
  ad {
  }
  ldap {
  }
}

analyzer {
 
  urls = [
    "https://download.thehive-project.org/analyzers.json"
  ]

  fork-join-executor {
    parallelism-min = 2
    parallelism-factor = 2.0
    parallelism-max = 4
  }
}

responder {
  urls = [
    "https://download.thehive-project.org/responders.json"
  ]

  fork-join-executor {
    parallelism-min = 2
    parallelism-factor = 2.0
    parallelism-max = 4
  }
}

```

Start the services:
```shell
docker-compose up -d
```
Access TheHive Web Interface:

Open: http://localhost:9000
Access Cortex Web Interface:

Open: http://localhost:9001


git clone https://github.com/StrangeBeeCorp/docker ./thehive_cortex

cd thehive_cortex/testing

## First steps / Initialisation
The application will run under the user account and group that executes the init script.

Run the init.sh script:

bash ./scripts/init.sh
This script wil perform following actions:

Prompts for a service name to include in the Nginx server certificate.
Initializes the secret.conf files for TheHive and Cortex.
Generates self-signed certificate none is found in ./certificates
Creates a .env file will user/group information and other application settings
Verifies file and folder permissions.

## Run the application stack

docker compose up -d


Access to the applications
Open your browser, and navigate to:

https://HOSTNAME_OR_IP/thehive to connect to TheHive
https://HOSTNAME_OR_IP/cortex to connect to Cortex




thehive
Login	admin
Password	secret




If cortex_6 is not listed, you'll need to create it:

curl -X PUT "localhost:9200/cortex_6"

curl -XPOST -H 'Content-Type: application/json' 'http://localhost:9001/api/organization' -d '{
"name": "cortex",
"description": "Cortex Organization",
"status": "Active"
}'

curl "http://localhost:9001/api/user" -H 'Content-Type: application/json' -d '
{
"login" : "admin",
"name" : "admin",
"roles" : [
"superadmin"
],
"preferences" : "{}",
"password" : "thehive1234",
"organization": "cortex"
}'

curl -u admin:thehive1234 "http://localhost:9001/api/organization" -H 'Content-Type: application/json' -d '
{
"name": "demo",
"description": "demo organization"
}'

curl -u admin:thehive1234 "http://localhost:9001/api/user" -H 'Content-Type: application/json' -d '
{
"login" : "thehive",
"name" : "thehive",
"roles" : [
"read",
"analyze",
"orgadmin"
],
"password" : "thehive1234",
"organization": "demo"
}'

key=$(curl -k -s -u admin:thehive1234 "$CORTEX_URL/api/user/thehive/key/renew" -d '')
echo $key > /tmp/cortex_key
curl "http://localhost:9001/api/user/thehive" -H 'Content-Type: application/json' -H "Authorization: Bearer $key"
