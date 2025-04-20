---
title:  Android SDK Command-Line Tools 
description: description
published: false
date: 2025-01-01
categories: 
tags: 
image:
  path: /assets/img/headers/image.webp
  lqip: data:image/webp;base64,
  alt: image
---

https://developer.android.com/studio#command-line-tools-only


https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip


To install the Android SDK command-line tools on Ubuntu, follow these steps:

1. Update and Install Required Packages
```shell
sudo apt update
sudo apt install openjdk-17-jdk unzip -y
```
2. Download Android Command-Line Tools

```shell
mkdir -p ~/android_sdk/cmdline-tools
cd ~/android_sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
unzip commandlinetools-linux-*.zip
mv cmdline-tools latest
mkdir -p ~/android_sdk/cmdline-tools/latest
mv latest ~/android_sdk/cmdline-tools/
```

3. Set Up Environment Variables

Edit your `~/.bashrc`:

```shell
nano ~/.bashrc
```
Add the following lines:

```shell
export ANDROID_HOME=$HOME/android_sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
```

Save and apply the changes:

```shell
source ~/.bashrc
```

4. Verify Installation
Run:

```shell
sdkmanager --list
```

If it runs successfully, your Android SDK command-line tools are installed.

5. Install SDK Components

To install essential components like platform-tools and build-tools, run:

```shell
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```
You can list available versions using:

```sh
sdkmanager --list
```

You're all set! 🚀 Let me know if you need further assistance.