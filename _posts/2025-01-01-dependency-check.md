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


Run OWASP Dependency-Check with Docker
You can scan a project directory by mounting it inside the container.

```shell
docker run --rm -v $(pwd):/src owasp/dependency-check --project "MyProject" --scan /src --format "HTML"
```
Explanation:
- --rm → Removes the container after execution.
- -v $(pwd):/src → Mounts the current project directory into /src inside the container.
- --project "MyProject" → Sets the project name for reporting.
- --scan /src → Scans the /src directory for dependencies.
- --format "HTML" → Generates an HTML report.
After the scan, the report will be available in your project folder as dependency-check-report.html.

Customize Output Formats
OWASP Dependency-Check supports multiple formats:

- HTML (for human-readable reports)
- JSON (for API integration)
- CSV (for data processing)
- JUNIT (for CI/CD test results)
