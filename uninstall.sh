#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

systemctl stop localtonet.service
systemctl disable localtonet.service
rm /lib/systemd/system/localtonet.service
rm -rf /opt/localtonet
