#!/usr/bin/env bash
set -euo pipefail

RELEASE_JSON=$(curl -fsSL https://api.github.com/repos/evilsocket/opensnitch/releases/latest)

DAEMON_URL=$(echo "$RELEASE_JSON" | grep -oE '"browser_download_url": *"[^"]*opensnitch-[0-9][^"]*\.x86_64\.rpm"' | cut -d'"' -f4)
UI_URL=$(echo "$RELEASE_JSON" | grep -oE '"browser_download_url": *"[^"]*opensnitch-ui-[0-9][^"]*\.noarch\.rpm"' | cut -d'"' -f4)

curl -fLo /tmp/opensnitch.rpm "$DAEMON_URL"
curl -fLo /tmp/opensnitch-ui.rpm "$UI_URL"

dnf5 install -y /tmp/opensnitch.rpm /tmp/opensnitch-ui.rpm
rm -f /tmp/opensnitch.rpm /tmp/opensnitch-ui.rpm