# Installation

Step 1: Place [`localtonet`](https://localtonet.com/download) in `/opt/localtonet/`.

Step 2: Add `localtonet.service` to `/lib/systemd/system/`.

Step 3: Go dashboard and get token edit localtonet.service file <<token>token> paste here.

Step 4: Start localtonet service by typing:

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
