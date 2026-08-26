#!/usr/bin/env bash
set -euo pipefail

echo ">>> Fetching latest OpenSnitch release metadata..."
RELEASE_JSON=$(curl -fsSL https://api.github.com/repos/evilsocket/opensnitch/releases/latest)

DAEMON_URL=$(echo "$RELEASE_JSON" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for asset in data['assets']:
    name = asset['name']
    if name.startswith('opensnitch-') and name.endswith('.x86_64.rpm') and not name.startswith('opensnitch-ui'):
        print(asset['browser_download_url'])
        break
")

UI_URL=$(echo "$RELEASE_JSON" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for asset in data['assets']:
    name = asset['name']
    if name.startswith('opensnitch-ui-') and name.endswith('.noarch.rpm'):
        print(asset['browser_download_url'])
        break
")

echo ">>> Daemon URL resolved: ${DAEMON_URL:-<EMPTY>}"
echo ">>> UI URL resolved: ${UI_URL:-<EMPTY>}"

if [[ -z "${DAEMON_URL}" || -z "${UI_URL}" ]]; then
  echo "ERROR: failed to resolve one or both OpenSnitch download URLs" >&2
  exit 1
fi

curl -fLo /tmp/opensnitch.rpm "$DAEMON_URL"
curl -fLo /tmp/opensnitch-ui.rpm "$UI_URL"

dnf5 install -y /tmp/opensnitch.rpm /tmp/opensnitch-ui.rpm
rm -f /tmp/opensnitch.rpm /tmp/opensnitch-ui.rpm