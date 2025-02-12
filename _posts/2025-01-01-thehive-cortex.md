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

https://github.com/StrangeBeeCorp/docker

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
