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

```shell
mkdir sonarqube && cd sonarqube
```

```yaml
services:
  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    networks:
      - sonarnet
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    depends_on:
      - db

  db:
    image: postgres:17
    container_name: postgres
    networks:
      - sonarnet
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - postgresql_data:/var/lib/postgresql/data
      - postgresql_data_conf:/etc/postgresql/postgresql.conf

networks:
  sonarnet:
    driver: bridge

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql_data:
  postgresql_data_conf:
```


```shell
docker-compose up -d
```



Once the containers are up and running, you can access SonarQube by navigating to <http://localhost:9000> in your web browser.

Log in with the default credentials:

- Username: admin
- Password: admin

After logging in, you will be prompted to change the default password.