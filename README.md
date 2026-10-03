# Localtonet headless systemd service

Linux x64 installer and service for a client supporting `--headless --authtoken-file`.
Check `/opt/localtonet/localtonet --help` before enabling this service; older
clients must be upgraded first.

## Install

Download and inspect the installer from the official repository:

```bash
curl -fsSLo install.sh https://raw.githubusercontent.com/localtonet/systemd-localtonet/main/install.sh
less install.sh
sudo bash install.sh
```

The installer downloads the Linux x64 client. It does not yet pin a client
version or verify a published SHA-256; do not treat it as a verified release
installer. It reloads systemd and starts/enables the service only when a
non-empty regular token file already exists. It never creates or prints a token.

## Configure authentication

Copy the device AuthToken from the Localtonet dashboard into a private file.
This Bash prompt keeps the token out of shell history and the service command:

```bash
sudo bash -c '
set -euo pipefail
install -d -m 0700 /etc/localtonet
token_file=/etc/localtonet/auth-token
if [ -e "$token_file" ] || [ -L "$token_file" ]; then
    echo "Token file already exists; edit it with sudoedit." >&2
    exit 1
fi
umask 077
IFS= read -r -s -p "Localtonet AuthToken: " token </dev/tty
printf "\n" >/dev/tty
[ -n "$token" ] || { echo "Empty token; no file created." >&2; exit 1; }
printf "%s\n" "$token" >"$token_file"
unset token
'
sudo systemctl enable --now localtonet.service
sudo systemctl status localtonet.service
```

For token rotation, use `sudoedit /etc/localtonet/auth-token`, retain root
ownership and mode `0600`, then run `sudo systemctl restart localtonet.service`.

## Manual installation and upgrades

Place the compatible client at `/opt/localtonet/localtonet`, make it executable,
and copy this repository's `localtonet.service` to
`/lib/systemd/system/localtonet.service`. Configure the token file as above,
then run `sudo systemctl daemon-reload` and enable/start the service.

An existing service with a token in its unit must first be migrated to the
private token file. After replacing its unit, run `daemon-reload` and
`systemctl restart localtonet.service`; `start` alone does not restart an
already running client.

## Lifecycle and integration boundary

Systemd restarts the client after exit and starts it at boot when enabled.
Stopping the service terminates its process group. The token is passed as a
file path rather than a command-line secret. This unit does not depend on
undocumented SIGHUP reload behavior; use `systemctl restart` for changes.

Tunnels still need dashboard configuration. This service adds no device-flow
login, endpoint-discovery API, or per-tunnel CLI. N-Craft's current Localtonet
runner starts its own client: do not run both it and this service with the
same AuthToken. Attaching N-Craft to a systemd-managed client needs a separate
integration change.
