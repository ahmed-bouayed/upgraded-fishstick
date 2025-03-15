---
title: OWASP ZAP 
description: web application security scanner
published: true
date: 2025-03-13
categories: DevOps
tags: docker security devsecops
image:
  path: /assets/img/headers/zap.webp
  lqip: data:image/webp;base64,UklGRpoAAABXRUJQVlA4II4AAABwBACdASoUAAsAPpE6l0eloyIhMAgAsBIJYwCsAYte7LtwJnVnD6fp+fhueAD++ZmuKwPpZGqPG/iaX2sxiSXrblGmfLEZWPAfAlrj0shK9+QvSmwTrlX/i9pvfj+f5RzU5nvxxhcb/nMDnO046fEGO2ouAREuMqi2Ie9+rXwdw5aF2KfBQVQUaxOcOAAA
  alt: ZAP
---

## what is OWASP ZAP?
ZAP (Zed Attack Proxy) is an open-source web application security scanner. It is designed to help security professionals and developers identify and fix vulnerabilities in web applications.

> ZAP can be integrated into CI/CD pipelines to perform Dynamic Application Security Testing (DAST).
{: .prompt-info }

## ZAP - Baseline Scan

It runs the ZAP spider against the specified target for (by default) 1 minute and then waits for the passive scanning to complete before reporting the results.

This means that the script doesn’t perform any actual ‘attacks’ and will run for a relatively short period of time (a few minutes at most).

By default it reports all alerts as WARNings but you can specify a config file which can change any rules to FAIL or IGNORE.

This script is intended to be ideal to run in a CI/CD environment, even against production sites.

```
Usage: zap-baseline.py -t <target> [options]
    -t target         target URL including the protocol, eg https://www.example.com
Options:
    -h                print this help message
    -c config_file    config file to use to INFO, IGNORE or FAIL warnings
    -u config_url     URL of config file to use to INFO, IGNORE or FAIL warnings
    -g gen_file       generate default config file (all rules set to WARN)
    -m mins           the number of minutes to spider for (default 1)
    -r report_html    file to write the full ZAP HTML report
    -w report_md      file to write the full ZAP Wiki (Markdown) report
    -x report_xml     file to write the full ZAP XML report
    -J report_json    file to write the full ZAP JSON document
    -a                include the alpha passive scan rules as well
    -d                show debug messages
    -P                specify listen port
    -D secs           delay in seconds to wait for passive scanning 
    -i                default rules not in the config file to INFO
    -I                do not return failure on warning
    -j                use the Ajax spider in addition to the traditional one
    -l level          minimum level to show: PASS, IGNORE, INFO, WARN or FAIL, use with -s to hide example URLs
    -n context_file   context file which will be loaded prior to spidering the target
    -p progress_file  progress file which specifies issues that are being addressed
    -s                short output format - dont show PASSes or example URLs
    -T mins           max time in minutes to wait for ZAP to start and the passive scan to run
    -U user           username to use for authenticated scans - must be defined in the given context file (post 2.9.0)
    -z zap_options    ZAP command line options e.g. -z "-config aaa=bbb -config ccc=ddd"
    --hook            path to python file that define your custom hooks
    --auto            use the automation framework if supported for the given parameters (this will become the default soon)
    --autooff         do not use the automation framework even if supported for the given parameters
```

To run it with no ‘file’ params use:
```shell
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://www.example.com
```
If you use ‘file’ params then you need to mount the directory those file are in or will be generated in, eg
```shell
docker run -v $(pwd):/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
    -t https://www.example.com -g gen.conf -r testreport.html
```
## ZAP - Full Scan

It runs the ZAP spider against the specified target (by default with no time limit) followed by an optional ajax spider scan and then a full active scan before reporting the results.

This means that the script does perform actual ‘attacks’ and can potentially run for a long period of time.

By default it reports all alerts as WARNings but you can specify a config file which can change any rules to FAIL or IGNORE. The configuration works in a very similar way as the Baseline Scan so see the Baseline page for more details.

```
Usage: zap-full-scan.py -t <target> [options]
    -t target         target URL including the protocol, eg https://www.example.com
Options:
    -h                print this help message
    -c config_file    config file to use to INFO, IGNORE or FAIL warnings
    -u config_url     URL of config file to use to INFO, IGNORE or FAIL warnings
    -g gen_file       generate default config file(all rules set to WARN)
    -m mins           the number of minutes to spider for (defaults to no limit)
    -r report_html    file to write the full ZAP HTML report
    -w report_md      file to write the full ZAP Wiki(Markdown) report
    -x report_xml     file to write the full ZAP XML report
    -J report_json    file to write the full ZAP JSON document
    -a                include the alpha active and passive scan rules as well
    -d                show debug messages
    -P                specify listen port
    -D                delay in seconds to wait for passive scanning 
    -i                default rules not in the config file to INFO
    -I                do not return failure on warning (post 2.9.0)
    -j                use the Ajax spider in addition to the traditional one
    -l level          minimum level to show: PASS, IGNORE, INFO, WARN or FAIL, use with -s to hide example URLs
    -n context_file   context file which will be loaded prior to scanning the target
    -p progress_file  progress file which specifies issues that are being addressed
    -s                short output format - dont show PASSes or example URLs
    -T                max time in minutes to wait for ZAP to start and the passive scan to run
    -U user           username to use for authenticated scans - must be defined in the given context file (post 2.9.0)
    -z zap_options    ZAP command line options e.g. -z "-config aaa=bbb -config ccc=ddd"
    --hook            path to python file that define your custom hooks
```

To run it with no ‘file’ params use:
```shell
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py -t https://www.example.com
```

If you use ‘file’ params then you need to mount the directory those file are in or will be generated in, eg
```shell
docker run -v $(pwd):/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-full-scan.py \
    -t https://www.example.com -g gen.conf -r testreport.html
```

## ZAP - API Scan

It is tuned for performing scans against APIs defined by OpenAPI, SOAP, or GraphQL via either a local file or a URL.

It imports the definition that you specify and then runs an Active Scan against the URLs found. The Active Scan is tuned to APIs, so it doesn’t bother looking for things like XSSs.

It also includes 2 scripts that:
- Raise alerts for any HTTP Server Error response codes
- Raise alerts for any URLs that return content types that are not usually associated with APIs

```
Usage: zap-api-scan.py -t <target> -f <format> [options]
    -t target         target API definition, OpenAPI or SOAP, local file or URL, e.g. https://www.example.com/openapi.json
                      or target endpoint URL, GraphQL, e.g. https://www.example.com/graphql
    -f format         openapi, soap, or graphql
Options:
    -h                print this help message
    -c config_file    config file to use to INFO, IGNORE or FAIL warnings
    -u config_url     URL of config file to use to INFO, IGNORE or FAIL warnings
    -g gen_file       generate default config file (all rules set to WARN)
    -r report_html    file to write the full ZAP HTML report
    -w report_md      file to write the full ZAP Wiki (Markdown) report
    -x report_xml     file to write the full ZAP XML report
    -J report_json    file to write the full ZAP JSON document
    -a                include the alpha passive scan rules as well
    -d                show debug messages
    -P                specify listen port
    -D                delay in seconds to wait for passive scanning 
    -i                default rules not in the config file to INFO
    -I                do not return failure on warning (post 2.9.0)
    -l level          minimum level to show: PASS, IGNORE, INFO, WARN or FAIL, use with -s to hide example URLs
    -n context_file   context file which will be loaded prior to scanning the target
    -p progress_file  progress file which specifies issues that are being addressed
    -s                short output format - dont show PASSes or example URLs
    -S                safe mode this will skip the active scan and perform a baseline scan
    -T                max time in minutes to wait for ZAP to start and the passive scan to run
    -U user           username to use for authenticated scans - must be defined in the given context file (post 2.9.0)
    -O                the hostname to override in the (remote) OpenAPI spec
    -z zap_options    ZAP command line options e.g. -z "-config aaa=bbb -config ccc=ddd"
    --hook            path to python file that define your custom hooks
    --schema          GraphQL schema location, URL or file, e.g. https://www.example.com/schema.graphqls
```

To use the API scanning script you just need to use the commands:

```shell
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-api-scan.py -t \  
    https://www.example.com/openapi.json -f openapi  
```

```shell
docker run -v $(pwd):/zap/wrk/:rw  ghcr.io/zaproxy/zaproxy zap-api-scan.py \
                    -t https://www.example.com/openapi.json \
                    -f openapi \
                    -r zap_report.html \
                    -w zap_report.md \
                    -J zap_json_report.json \
                    -x zap_xml_report.xml \
                    -c zap_ignore_rules
```

By default the script:
- Imports the API definition supplied
- Actively scans the API using a custom scan profile tuned for APIs
- Reports any issues found to the command line