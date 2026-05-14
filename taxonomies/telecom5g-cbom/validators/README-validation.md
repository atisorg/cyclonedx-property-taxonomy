# ATIS telecom5g CBOM validation (v0.6)

This package provides three artifacts:

1) `atis-telecom5g-property-taxonomy-v0.6.md`  
   Human-readable taxonomy (published in the CycloneDX property taxonomy repository).

2) `atis-telecom5g-taxonomy-0.6.json`  
   Machine-readable extract of the taxonomy (property names + constraints).

3) `atis-telecom5g-profile-0.6.schema.json`  
   A JSON Schema **overlay** that validates:
   - CycloneDX 1.7 schema conformance (via `$ref` to the official CycloneDX schema), and
   - conformance to ATIS telecom5g property naming/value rules.

## What this overlay validates

- The BOM must be valid CycloneDX 1.7 JSON.
- The BOM must contain BOM-level markers:
  - `atis:telecom5g:profile = 3gpp-5g-arch-cbom/0.6`
  - `atis:telecom5g:cbom.scope = vendor|deployed`
- Any property whose name begins with `atis:telecom5g:` must:
  - be defined by the taxonomy (or match one of the allowed patterns, e.g., `atis:telecom5g:iface.<Interface>.*`), and
  - have a value conforming to its enum/pattern.

## Run validation with AJV

Download the CycloneDX 1.7 schema (as published):
- `http://cyclonedx.org/schema/bom-1.7.schema.json`

Then run:

```bash
ajv validate --spec=draft7 --all-errors --errors=text \
  -s atis-telecom5g-profile-0.6.schema.json \
  -r bom-1.7.schema.json \
  -d your-bom.json
```

## Convenience scripts
- Windows PowerShell: `validate-cbom.ps1`
- Bash: `validate-cbom.sh`
