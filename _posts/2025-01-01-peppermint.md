---
title: Peppermint
description: Help Desk, lightweight ticketing system
published: true
date: 2025-03-15
categories: service
tags: docker
image:
  path: /assets/img/headers/peppermint.webp
  lqip: data:image/webp;base64,UklGRmoAAABXRUJQVlA4IF4AAACQAwCdASoUAAsAPpE6l0eloyIhMAgAsBIJZwDE2CHM08+6vZQAAP72a+zxP8zcN34LqSLLPxyfmRY5EnqRJCknR/CKVEnhM6V8XVObBSgOkecq/pmz9gN/AE+tgAAA
  alt: Peppermint
---

## Introduction to Peppermint Help Desk
Peppermint Help Desk is an open-source, lightweight ticketing system designed to help small teams manage support requests efficiently. It’s simple to set up, customizable, and can be deployed using Docker, making it an excellent choice for those who want a self-hosted help desk solution without the complexity of larger platforms.
In this guide, we’ll walk through installing Peppermint Help Desk using Docker and Docker Compose, ensuring you can get it up and running quickly.


## Prerequisites
Before you begin, ensure you have the following installed:
- Docker
- Docker Compose

## Setting Up Peppermint Help Desk with Docker
Peppermint Help Desk provides an official Docker image, and we’ll use Docker Compose to manage the application and its database. Follow these steps:
### 1. Create a Project Directory
Create a new directory for your Peppermint setup and navigate into it:
```shell
mkdir peppermint
cd peppermint
```
### 2. Create a Docker Compose File
Inside the directory, create a file named `docker-compose.yaml` and add the following configuration:

```yaml
services:
  db:
    image: postgres:latest
    restart: unless-stopped
    ports:
      - 5432:5432
    volumes:
      - peppermint_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: peppermint
      POSTGRES_PASSWORD: your_secure_password
      POSTGRES_DB: peppermint

  app:
    image: pepperlabs/peppermint:latest
    ports:
      - 3000:3000
      - 5003:5003
    restart: unless-stopped
    depends_on:
      - db
    environment:
      DB_USERNAME: "peppermint"
      DB_PASSWORD: "your_secure_password"
      DB_HOST: "db"
      SECRET: 'peppermint4life'

volumes:
 peppermint_data:
```
Replace `your_secure_password` with a strong password of your choice.
### 3. Start Peppermint Help Desk
Run the following command to start the application and database:
```shell
docker-compose up -d
```
This will pull the necessary images, set up the containers, and run them in the background.
### 4. Verify It’s Running
Check that the containers are up and running:
```shell
docker ps
```
You should see two containers: one for the Peppermint app and one for the PostgreSQL database.
## Accessing Peppermint Help Desk
Once the containers are running, open your browser and navigate to:
<http://localhost:3000>
You’ll be greeted with the Peppermint login page. The default credentials are:
```
Username: admin@admin.com
Password: 1234
```
> Security Note: Change the default password immediately after logging in for the first time!
{: .prompt-warning }

## Basic Configuration
After logging in, you can:
- Add users and assign roles (e.g., agents or admins).
- Create ticket categories and customize workflows.
- Set up email notifications (requires additional SMTP configuration in the environment variables).

Refer to the official Peppermint documentation for advanced configuration options.

## Troubleshooting
- Container Won’t Start?
Check the logs for errors:
```shell
docker-compose logs app
docker-compose logs db
```
- Database Connection Issues?
Ensure the `DB_` environment variables in the `docker-compose.yaml` match the `POSTGRES_` variables for the database service.
- Restart Containers
If needed, restart the setup:
```shell
docker-compose restart
```

## Conclusion
Peppermint Help Desk is a fantastic, lightweight solution for managing support tickets. With Docker, deployment is a breeze, and you can scale it as your team grows. Let me know in the comments if you run into any issues or have tips to share!
