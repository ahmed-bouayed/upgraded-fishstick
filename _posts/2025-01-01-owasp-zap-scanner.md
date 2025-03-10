---
title: title
description: description
published: false
date: 2025-01-01
categories: docker
tags: docker
image:
  path: /assets/img/headers/image.webp
  lqip: data:image/webp;base64,
  alt: image
---


```groovy
 stage('DAST - OWASP ZAP') {
            when {
                branch 'PR*'
            }
            steps {
                sh '''
                    #### REPLACE below with Kubernetes http://IP_Address:30000/api-docs/ #####
                    chmod 777 $(pwd)
                    docker run -v $(pwd):/zap/wrk/:rw  ghcr.io/zaproxy/zaproxy zap-api-scan.py \
                    -t http://134.209.155.222:30000/api-docs/ \
                    -f openapi \
                    -r zap_report.html \
                    -w zap_report.md \
                    -J zap_json_report.json \
                    -x zap_xml_report.xml \
                    -c zap_ignore_rules
                '''
            }
        }
```

 OWASP ZAP for Security Scanning in DevOps
OWASP ZAP can be integrated into CI/CD pipelines to perform Dynamic Application Security Testing (DAST). You can use:

- ZAP CLI (Command Line Interface)
- ZAP Docker Image
- ZAP API Automation
- ZAP Baseline Scan (for quick scans)

Example: Running OWASP ZAP in a DevOps Pipeline
Using Docker:

```shell
docker run -t owasp/zap2docker-stable zap-baseline.py -t https://your-app.com
```