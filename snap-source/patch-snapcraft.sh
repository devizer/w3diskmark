#!/usr/bin/env bash
set -eu; set -o pipefail

file="${1:-}"
key="${2:-}"
value="${3:-}"

echo "PATCH SNAPCRAFT DEFINITION '$file': SET '$key' = '$value'"

sed -i "/^$key\:/d" snap/snapcraft.yaml; printf "\n\n$key: $value\n" >> snap/snapcraft.yaml;
