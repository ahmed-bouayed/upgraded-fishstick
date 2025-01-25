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

sudo apt update

Installing Required Dependencies
To begin the installation process, you need to install several dependencies on your Ubuntu 22.04 server. Open a terminal and enter the following command to install all the necessary dependencies:

sudo apt install build-essential libpcap-dev libpcre3-dev libnet1-dev zlib1g-dev luajit hwloc libdnet-dev libdumbnet-dev bison flex liblzma-dev openssl libssl-dev pkg-config libhwloc-dev cmake cpputest libsqlite3-dev uuid-dev libcmocka-dev libnetfilter-queue-dev libmnl-dev autotools-dev libluajit-5.1-dev libunwind-dev libfl-dev -y

apt install build-essential libpcap-dev libpcre3-dev libnet1-dev zlib1g-dev luajit hwloc libdnet-dev libdumbnet-dev bison flex liblzma-dev openssl libssl-dev pkg-config libhwloc-dev cmake cpputest libsqlite3-dev uuid-dev libcmocka-dev libnetfilter-queue-dev libmnl-dev autotools-dev libluajit-5.1-dev libunwind-dev libfl-dev -y

sudo apt install -y gcc libpcre3-dev zlib1g-dev libluajit-5.1-dev 
libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev 
bison flex libdnet autoconf libtool

sudo apt -y install libpcre3 libpcre3-dbg libpcre3-dev libpcap-dev\
    build-essential autoconf automake libtool libnet1-dev \
    libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
    make flex bison git wget libmagic-dev pkg-config libnuma-dev strace \
    perl libio-socket-ssl-perl libcrypt-ssleay-perl ca-certificates libwww-perl \
    python-pip python-pcapy python-dpkt supervisor openssh-server net-tools \
    iputils-ping


sudo apt install -y gcc libpcre3-dev zlib1g-dev libluajit-5.1-dev 
libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev 
bison flex libdnet autoconf libtool




Start by making a temporary download folder to your home directory and then changing into it with the command below.

mkdir ~/snort_src && cd ~/snort_src

Then, download and install the latest version of the Snort Data Acquisition library (LibDAQ). For installing LibDAQ we'll need to build and install it from the source with the following command.

4. Installing Snort DAQ
Next, you need to install the Data Acquisition (DAQ) library, which is a prerequisite for Snort. By default, the DAQ library is not available in the Ubuntu default repository, so you will have to compile it from source. Follow the steps below to install Snort DAQ:

Download the Snort DAQ source code from Git by running the following command:
git clone https://github.com/snort3/libdaq.git
Once the download is complete, navigate to the downloaded directory and configure it using the following commands:
cd libdaq

Compile and install Snort DAQ by running the following commands:
make
make install

-------
The next dependency is Tcmalloc, which will optimize memory allocation and provide better memory usage.

Install Tcmalloc with the following command.

cd ../
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9/gperftools-2.9.tar.gz
tar xzf gperftools-2.9.tar.gz 
cd gperftools-2.9/
./configure
make 
make install

------
5. Installing Gperftools
Gperftools is a set of performance analysis tools that Snort uses. To install Gperftools, follow the steps below:

Download the latest version of Gperftools by running the following command:
cd
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz
Once the download is complete, extract the downloaded file using the following command:
tar xzf gperftools-2.9.1.tar.gz
Navigate to the extracted directory and compile Gperftools by running the following commands:
cd gperftools-2.9.1/
./configure
make
make install



You can also get the code with:

git clone https://github.com/snort3/snort3.git


cd snort3/


./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc

./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
make
make install
ldconfig

Setup install path:

export my_path=/path/to/snorty
Compile and install:

To build with cmake and make, run configure_cmake.sh. It will automatically create and populate a new subdirectory named 'build'.

./configure_cmake.sh --prefix=$my_path
cd build
make -j $(nproc) install



nano /etc/snort


sudo cp snort.conf snort.conf.backup



sudo nano snort.conf



------


01. Clone Snort 3 official GitHub repository.

cd ../
git clone git://github.com/snortadmin/snort3.git
02. Change the directory to Snort3

cd snort3/
03. From there configure and enable tcmalloc with the following command.

./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
04. Navigate to build directory and compile and install Snort 3 using make and make install with the following command.

cd build
make 
make install
05. When the installation is done, update shared libraries.

sudo ldconfig
Snort by default is installed to /usr/local/bin/snort directory, it is good practice to create a symbolic link for /usr/sbin/snort

sudo ln -s /usr/local/bin/snort /usr/sbin/snort
06. Verify Snort 3 installation

snort -V


----


7. Configuring Snort
Before you can start using Snort, you need to configure it. Follow the steps below:

Set your network interface to promiscuous mode so that Snort can analyze all network traffic by running the following command:
ip linkset dev eth0 promisc on
Verify that the interface is set to promiscuous mode by running the following command:
ip add sh eth0
Disable Interface Offloading to ensure accurate packet analysis. Check if this feature is enabled by running the following command:
ethtool -k eth0 | grep receive-offload
Disable Interface Offloading by running the following command:
ethtool -K eth0 gro off lro off











#######
Step 1: Make Promiscuous Mode Persistent
To enable promiscuous mode permanently, you can use a systemd service or modify the network configuration.

Option 1: Using netplan (if your system uses netplan)
Edit your Netplan configuration file (usually located in /etc/netplan/):



sudo nano /etc/netplan/01-netcfg.yaml
Add the following lines under the appropriate network interface:

network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]  # Replace with your static IP
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
      optional: true
      link-local: []
      match:
        macaddress: xx:xx:xx:xx:xx:xx  # Replace with your MAC address
      set-name: eth0
      routes:
        - to: 0.0.0.0/0
          via: 192.168.1.1
      # Add this line to enable promiscuous mode
      accept-all-mac-addresses: true
Save and apply the changes:



sudo netplan apply
Option 2: Using a systemd Service
Create a systemd service file:



sudo nano /etc/systemd/system/set-promisc.service
Add the following content:

[Unit]
Description=Set eth0 to promiscuous mode
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ip link set dev eth0 promisc on
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
Enable and start the service:



sudo systemctl enable set-promisc.service
sudo systemctl start set-promisc.service
Step 2: Make Interface Offloading Changes Persistent
To disable GRO (Generic Receive Offload) and LRO (Large Receive Offload) permanently, you can use a systemd service.

Create a systemd service file:



sudo nano /etc/systemd/system/disable-offloading.service
Add the following content:

[Unit]
Description=Disable GRO and LRO on eth0
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -K eth0 gro off lro off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
Enable and start the service:



sudo systemctl enable disable-offloading.service
sudo systemctl start disable-offloading.service
Step 3: Verify Persistent Changes
Reboot your VM:



sudo reboot
After the reboot, verify the settings:

Check promiscuous mode:



ip addr show eth0
Look for the PROMISC flag.

Check offloading settings:



ethtool -k eth0 | grep receive-offload
Ensure generic-receive-offload and large-receive-offload are set to off.

Step 4: Test Snort
Run Snort in NIDS mode to ensure it works as expected:



sudo snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i eth0
