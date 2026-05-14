# ATIS CycloneDX Property Taxonomies

This repository hosts **ATIS-managed CycloneDX property taxonomies** and related artifacts (profiles, validators, examples, and implementation guidance).  
The goal is to make domain-specific BOM data **consistent, interoperable, and tool-friendly** across vendors, operators, and ecosystem tools.

## What you’ll find here

- **Taxonomy specifications** (human-readable Markdown) defining property names, value rules, and usage guidance
- **Machine-readable extracts** (JSON) for automation and validator generation
- **Profile and validation artifacts** to help implementers validate conformance
- **Examples** to demonstrate recommended modeling patterns

## Repository layout

Top-level structure is designed to support **multiple ATIS taxonomies** over time.

```
/
  README.md
  LICENSE
  CONTRIBUTING.md
  /taxonomies/
    /telecom5g-cbom/
      README.md
      /taxonomy/
      /profile/
      /validators/
      /examples/
      /guides/
      /tools/
      /releases/
    /<future-taxonomy>/
      ...
```

## Available taxonomies

| Taxonomy | Current version | Description | Entry point |
|---|---:|---|---|
| **Telecom 5G CBOM** | v0.6 | ATIS `atis:telecom5g` property taxonomy for 3GPP 5G security architecture CBOMs (CycloneDX 1.7) | `taxonomies/telecom5g-cbom/README.md` |

## Quick start

### 1) Use the normative taxonomy
Start with the Markdown taxonomy document for your chosen taxonomy (for 5G: `atis:telecom5g`).  
It is the authoritative reference for:
- property names
- controlled vocabularies/enums
- placement guidance and modeling patterns

### 2) Validate CBOMs
Implementers should validate CBOMs in two layers:

1. **CycloneDX schema validation** (e.g., CycloneDX CLI or schema validator)
2. **ATIS taxonomy/profile conformance** (overlay schema / linter)

Each taxonomy folder includes validator artifacts and helper scripts under `validators/`.

## Adding new ATIS taxonomies

New taxonomies should be added under `taxonomies/<taxonomy-name>/` using the same structure as the 5G CBOM package:
- `taxonomy/` (normative taxonomy + machine extract)
- `profile/` (how to use CycloneDX for that domain)
- `validators/` (overlay schema and optional modules)
- `examples/` (reference examples)
- `guides/` (implementation guide / notes)

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Versioning

Taxonomy packages use **semantic versioning** at the package level (e.g., `v0.6`).
- Increment **minor** versions when adding new properties/enums in a backward-compatible way
- Increment **major** versions for breaking changes (renames/removals, semantic reversals)

## License

Unless stated otherwise within a subdirectory, content in this repository is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE).
