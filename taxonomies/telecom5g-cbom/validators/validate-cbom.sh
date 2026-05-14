#!/usr/bin/env bash
set -euo pipefail

BOM_PATH="${1:-}"
OVERLAY_SCHEMA="${2:-./atis-telecom5g-profile-0.6.schema.json}"
CYCLONE_SCHEMA="${3:-./bom-1.7.schema.json}"

if [[ -z "$BOM_PATH" ]]; then
  echo "Usage: ./validate-cbom.sh <bom.json> [overlay-schema.json] [cyclonedx-schema.json]"
  exit 2
fi

echo "== ATIS telecom5g CBOM validation (v0.6) =="

# 1) CycloneDX schema validation (recommended): cyclonedx-cli if installed
if command -v cyclonedx-cli >/dev/null 2>&1; then
  echo "[1/2] CycloneDX 1.7 schema validation via cyclonedx-cli"
  cyclonedx-cli validate --input-file "$BOM_PATH" --input-format json --input-version v1_7
else
  echo "[1/2] cyclonedx-cli not found; skipping CycloneDX CLI validation."
  echo "      Install from: https://github.com/CycloneDX/cyclonedx-cli"
fi

# 2) ATIS overlay validation via ajv-cli
AJV_BIN="ajv"
command -v ajv >/dev/null 2>&1 || AJV_BIN="ajv.cmd"

if ! command -v "$AJV_BIN" >/dev/null 2>&1; then
  echo "ajv-cli not found. Install with: npm install -g ajv-cli"
  exit 1
fi

if [[ ! -f "$CYCLONE_SCHEMA" ]]; then
  echo "CycloneDX schema not found locally, downloading: $CYCLONE_SCHEMA"
  curl -fsSL "http://cyclonedx.org/schema/bom-1.7.schema.json" -o "$CYCLONE_SCHEMA"
fi

echo "[2/2] ATIS telecom5g overlay validation via ajv-cli"
set +e
$AJV_BIN validate --spec=draft7 --all-errors --errors=text --strict=false --formats=false \
  -s "$OVERLAY_SCHEMA" -r "$CYCLONE_SCHEMA" -d "$BOM_PATH"
RC=$?
if [[ $RC -ne 0 ]]; then
  echo "Retrying without --strict/--formats (if unsupported)..."
  $AJV_BIN validate --spec=draft7 --all-errors --errors=text \
    -s "$OVERLAY_SCHEMA" -r "$CYCLONE_SCHEMA" -d "$BOM_PATH"
  RC=$?
fi
set -e
exit $RC
