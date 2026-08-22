#!/usr/bin/env bash
set -euo pipefail

VERSION_ID=$(source /usr/lib/os-release; echo "$VERSION_ID")

curl -fsSL https://negativo17.org/repos/fedora-spotify.repo \
  | sed "s/\$releasever/${VERSION_ID}/g" \
  > /etc/yum.repos.d/fedora-spotify.repo