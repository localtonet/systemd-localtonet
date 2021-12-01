#!/usr/bin/env bash

if [ ! $(which wget) ]; then
    echo 'Please install wget package'
    exit 1
fi

if [ ! $(which git) ]; then
    echo 'Please install git package'
    exit 1
fi

if [ ! $(which unzip) ]; then
    echo 'Please install zip package'
    exit 1
fi

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

if [ ! -e localtonet.service ]; then
    git clone --depth=1 https://github.com/ShiftyTR/systemd-localtonet.git
    cd systemd-localtonet
fi
cp localtonet.service /lib/systemd/system/
mkdir -p /opt/localtonet

cd /opt/localtonet
wget https://localtonet.com/download/linux-x64.zip
unzip linux-x64.zip
rm linux-x64.zip
chmod +x localtonet

systemctl enable localtonet.service
systemctl start localtonet.service
