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

docker compose up
or

docker compose up -d


Access to the applications
Open your browser, and navigate to:

https://HOSTNAME_OR_IP/thehive to connect to TheHive
https://HOSTNAME_OR_IP/cortex to connect to Cortex




## Demo data
Run the following script to configure TheHive and Cortex with sample data:

bash ./scripts/test_init_applications.sh
This scripts will:

Initialize Cortex with a Demo organisation and thehive account
Enable some free Analyzers
Initialize TheHive with a Demo organisation and thehive account
Integrate TheHive with Cortex
Add sample data like Alerts, Observables, Custom fields.


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
