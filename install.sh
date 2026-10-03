#!/usr/bin/env bash
set -euo pipefail

if ! command -v wget >/dev/null 2>&1; then
    echo 'Please install wget package'
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo 'Please install git package'
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    echo 'Please install zip package'
    exit 1
fi

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

if [ ! -e localtonet.service ]; then
    git clone --depth=1 https://github.com/localtonet/systemd-localtonet.git
    cd systemd-localtonet
fi
cp localtonet.service /lib/systemd/system/
mkdir -p /opt/localtonet

cd /opt/localtonet
wget https://localtonet.com/download/linux-x64.zip
unzip linux-x64.zip
rm linux-x64.zip
chmod +x localtonet

install -d -m 0700 /etc/localtonet
systemctl daemon-reload
if [ -f /etc/localtonet/auth-token ] && [ ! -L /etc/localtonet/auth-token ] && [ -s /etc/localtonet/auth-token ]; then
    chown root:root /etc/localtonet/auth-token
    chmod 0600 /etc/localtonet/auth-token
    systemctl enable localtonet.service
    systemctl start localtonet.service
else
    echo 'Client installed. Configure /etc/localtonet/auth-token as described in README.md, then enable/start the service.'
fi
