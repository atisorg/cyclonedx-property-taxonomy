param(
  [Parameter(Mandatory=$true)][string]$BomPath,
  [string]$OverlaySchema = ".\atis-telecom5g-profile-0.6.schema.json",
  [string]$CycloneSchema = ".\bom-1.7.schema.json"
)

Write-Host "== ATIS telecom5g CBOM validation (v0.6) =="

if (!(Test-Path $BomPath)) { throw "BOM not found: $BomPath" }
if (!(Test-Path $OverlaySchema)) { throw "Overlay schema not found: $OverlaySchema" }

# 1) CycloneDX 1.7 schema validation (recommended): cyclonedx-cli if available
$cdx = Get-Command cyclonedx-cli -ErrorAction SilentlyContinue
if ($cdx) {
  Write-Host "[1/2] CycloneDX 1.7 schema validation via cyclonedx-cli"
  & cyclonedx-cli validate --input-file $BomPath --input-format json --input-version v1_7
  if ($LASTEXITCODE -ne 0) { throw "CycloneDX schema validation failed." }
} else {
  Write-Host "[1/2] cyclonedx-cli not found; skipping CycloneDX CLI validation."
  Write-Host "      Install from: https://github.com/CycloneDX/cyclonedx-cli"
}

# 2) ATIS telecom5g taxonomy/profile validation (overlay) via ajv-cli
$ajv = Get-Command ajv.cmd -ErrorAction SilentlyContinue
if (!$ajv) { throw "ajv.cmd not found. Install ajv-cli: npm.cmd install -g ajv-cli" }

if (!(Test-Path $CycloneSchema)) {
  Write-Host "CycloneDX schema not found locally, downloading: $CycloneSchema"
  Invoke-WebRequest -Uri "http://cyclonedx.org/schema/bom-1.7.schema.json" -OutFile $CycloneSchema
}

Write-Host "[2/2] ATIS telecom5g overlay validation via ajv-cli"

# Try best-effort flags; fall back if unsupported by this ajv-cli version.
$cmd1 = "ajv.cmd validate --spec=draft7 --all-errors --errors=text --strict=false --formats=false -s `"$OverlaySchema`" -r `"$CycloneSchema`" -d `"$BomPath`""
Write-Host "Running: $cmd1"
Invoke-Expression $cmd1
if ($LASTEXITCODE -ne 0) {
  Write-Host "Retrying without --strict/--formats (if unsupported)..."
  $cmd2 = "ajv.cmd validate --spec=draft7 --all-errors --errors=text -s `"$OverlaySchema`" -r `"$CycloneSchema`" -d `"$BomPath`""
  Write-Host "Running: $cmd2"
  Invoke-Expression $cmd2
}
