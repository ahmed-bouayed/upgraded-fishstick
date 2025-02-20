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

Guide to launching Reaver
Once you’ve found a network you wish to run the attack against, operating Reaver is very straightforward. The basic command needs only the local interface, channel, and ESSID to be specified. The command to launch Reaver against the “linksys” network above would look like this:

reaver -i wlp3s0 -b 00:23:69:48:33:95 -c 5 -vv

The only part of the above command that might not be immediately obvious is “-vv”; this enables verbose output which greatly helps when trying to gauge how well Reaper is (or is not) progressing.

Advanced options for Reaver
Ideally, the basic command works and the attack progresses as expected. But in reality, different manufacturers have been trying to implement protections against Reaver-style attacks, and additional options may be required to get the attack moving.

As an example, the following command adds a few optional switches that can help to get Reaver working on more picky devices:

reaver -i mon0 -c 6 -b 00:23:69:48:33:95 -vv -L -N -d 15 -T .5 -r 3:15

The core command hasn’t changed, the additional switches just change how Reaver behaves:

-L

Ignore locked WPS state.

-N

Don’t send NACK packets when errors are detected.

-d 15

Delay 15 seconds between PIN attempts.

-T

Set timeout period to half a second.

-r 3:15

After 3 attempts, sleep for 15 seconds

This is by no means an exhaustive list of Reaver options, but it gives an idea on what kind of things you might want to try.
