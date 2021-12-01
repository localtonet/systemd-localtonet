# Installation

Step 1: Place [`localtonet`](https://localtonet.com/download) in `/opt/localtonet/`.

Step 4: Add `localtonet.service` to `/lib/systemd/system/`.

Step 5: Start localtonet service by typing:

```
    systemctl enable localtonet.service
    systemctl start localtonet.service
```

or just execute `install.sh` on Linux x64 platform.

```
    curl -O https://raw.githubusercontent.com/shiftytr/systemd-localtonet/master/install.sh
    chmod +x install.sh
    sudo ./install.sh
```
