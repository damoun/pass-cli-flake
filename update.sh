#!/usr/bin/env bash
set -euo pipefail

URL="https://proton.me/download/pass-cli/versions.json"
TEMP_FILE=$(mktemp)

cleanup() {
  rm -f "$TEMP_FILE"
}
trap cleanup EXIT

echo "Downloading $URL..."
curl -sSL "$URL" -o "$TEMP_FILE"

echo "Validating schema..."
nix run nixpkgs#check-jsonschema -- --schemafile schema.json "$TEMP_FILE"

expected=$(cat .version)
actual=$(jq -r .passCliVersions.version "$TEMP_FILE")
if [[ "$actual" != "$expected" ]]; then
  echo "Proton serves $actual, .version is $expected" >&2
  exit 1
fi

mv "$TEMP_FILE" versions.json
echo "Successfully updated versions.json"
