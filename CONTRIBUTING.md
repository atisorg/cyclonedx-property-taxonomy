# Contributing

Thank you for helping improve ATIS CycloneDX property taxonomies.

This repository is intended to host **stable, implementer-focused** taxonomies and supporting artifacts that enable consistent interchange and validation of BOM data.

> Note: Even if you are not a code or documentation contributor, you can still participate by submitting requests and feedback through GitHub Issues (see **Submitting requests** below).

## Ways to contribute

- Suggest new properties, enums, or patterns for an existing taxonomy
- Report ambiguities or gaps (especially where standards alignment is unclear)
- Add or improve example CBOMs
- Improve validator overlays and helper scripts
- Propose a new ATIS taxonomy package (new domain)

## Submitting requests (no code required)

If you would like ATIS to add/adjust properties, examples, validators, or guidance, the preferred path is to open a **GitHub Issue**.

### 1) Open a GitHub Issue
Use the repository **Issues** tab and create a new issue. Please include as much of the following as possible:

- **Taxonomy/package name** (e.g., `telecom5g-cbom`)
- **Version** you are referencing (e.g., v0.6)
- **Request type**: property / enum / example / validator / documentation
- **What you want to change** (clear description)
- **Why** (the problem it solves; consumer impact)
- **Standards alignment** (3GPP spec + section if available)
- **Example** (a small CBOM fragment or snippet showing desired usage)

### 2) What happens next (maintainer workflow)
Issues are triaged by the maintainer and typically labeled as one of:
- `accepted` – planned for inclusion
- `needs-info` – more detail needed (e.g., spec section, example)
- `deferred` – acknowledged but not scheduled yet
- `rejected` – not aligned with scope or duplicates another mechanism

For accepted items, the maintainer will map the change to the next appropriate release and update CHANGELOG notes.

### 3) Submitting a Pull Request (optional)
If you are able to implement changes yourself:
1. Fork the repository
2. Create a branch
3. Submit a Pull Request referencing the Issue (e.g., “Fixes #123”)

PRs are reviewed and merged by the maintainer.

## Ground rules

- **Do not** duplicate the same taxonomy content in multiple places.
- Treat `taxonomies/<name>/taxonomy/*.md` as the **normative taxonomy** for that package.
- Keep examples in `examples/` and treat them as **informative**, not normative.
- Keep validators in `validators/` and ensure they remain usable with common tooling (AJV, CycloneDX CLI).

## Proposed structure for taxonomy packages

Each taxonomy package should follow the same structure:

```
taxonomies/<taxonomy-name>/
  README.md
  taxonomy/
    <taxonomy>-vX.Y.md
    <taxonomy>-X.Y.json          # machine-readable extract (recommended)
  profile/
    <profile>-vX.Y.md
  validators/
    <overlay>-X.Y.schema.json
    README-validation.md
    validate-*.ps1 / validate-*.sh
    modules/                     # optional scenario validators
  examples/
    README.md
    vendor/
    deployed/
    negative-tests/
  guides/
    <implementation-guide>-vX.Y.md
  releases/
    vX.Y/
      <optional zip/manifests>
```

## Contribution workflow

1. **Open an issue first** for substantial changes (new property sets, new modules, new taxonomy packages).
2. Create a branch and submit a PR referencing the issue.
3. Keep changes small and reviewable when possible.

### PR checklist (for taxonomy changes)

- [ ] Updated the normative taxonomy Markdown (`taxonomy/*.md`)
- [ ] Updated machine-readable taxonomy extract (`taxonomy/*.json`) if present
- [ ] Updated overlay schema (`validators/*.schema.json`) to reflect new rules
- [ ] Added/updated examples demonstrating the new properties
- [ ] Updated any implementation guide sections affected
- [ ] Ran validation on examples (CycloneDX + overlay) and documented results

## Validation expectations

When a taxonomy publishes an overlay schema, it should validate:
- **CycloneDX schema conformance** (by referencing the official CycloneDX schema)
- **Taxonomy conformance** for ATIS namespace properties:
  - property names are recognized
  - values match enums/patterns
  - required BOM markers (profile version, scope) are present

Scenario-specific validators (modules) may be published under `validators/modules/` but should be clearly labeled as optional.

## Versioning and releases

- Use semantic versioning (e.g., `v0.6` → `v0.7`).
- Avoid breaking changes unless necessary; if needed, bump major version and provide migration notes.

If you create a release:
- Tag the repository (or package) for the version
- Place any convenience bundles under `releases/vX.Y/`
- Update the package README with the latest version and links

## Code of conduct

Be respectful, assume good intent, and focus discussions on technical clarity and implementer usability.
