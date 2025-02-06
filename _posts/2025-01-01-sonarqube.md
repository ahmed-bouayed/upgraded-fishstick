---
title: sonarqube
description: code analysis tool for code quality and security
published: true
date: 2025-02-04
categories: devops
tags: docker test devops ci
image:
  path: /assets/img/headers/sonarqube.webp
  lqip: data:image/webp;base64,UklGRmQAAABXRUJQVlA4IFgAAACwAwCdASoUAAoAPpE4mEeloyKhMAgAsBIJZwDCgCHhmIdglekAAAD++y//gRkFEoLnIAIGiSKfR/8RelnLcEzcYRU/1oyRnO93XPJUKiwR2ZD6yL5DqAAA
  alt: sonarqube
---


## what is SAST
SAST, or Static Application Security Testing, scans the source code of an application to identify vulnerabilities within the code itself


## what is sonarqube

SonarQube Server is an on-premise analysis tool designed to detect coding issues in `30+ languages`, `frameworks`, and `IaC platforms`. By integrating directly with your `CI pipeline` or on one of our supported DevOps platforms, your code is checked against an extensive set of rules that cover many attributes of code, such as maintainability, reliability, and security issues on each merge/pull request. 

As a core element of the Sonar solution, SonarQube Server completes the analysis loop to help you deliver clean code that meets high-quality standards.

## how to Install sonarqube:
add these lines to `/etc/sysctl.conf`:
```shell
vm.max_map_count=524288
fs.file-max=131072
```
To apply the changes, run:
```shell
sudo sysctl -p
```

create folder `sonarqube`:
```shell
mkdir sonarqube && cd sonarqube
```

create `docker-compose.yaml`:
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

run the command:
```shell
docker-compose up -d
```

Once the containers are up and running, you can access SonarQube by navigating to <http://localhost:9000> in your web browser.

Log in with the default credentials:

- Username: admin
- Password: admin

After logging in, you will be prompted to change the default password.