# `atis:telecom5g` Namespace Taxonomy (Draft v0.1)

This document defines the namespaces and properties used by the **`atis:telecom5g`** top-level namespace for a **3GPP 5G Architecture CBOM Profile** built on **CycloneDX 1.7**.

## Namespace structure note
ATIS is the registered **top-level namespace** (`atis`). The 5G CBOM properties are defined under the **sub-namespace** `atis:telecom5g`. This aligns with CycloneDX guidance that namespaces are hierarchical and delimited with `:`. citeturn0search0turn0search7


The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

> Note: CycloneDX “properties” are generic name/value pairs. This taxonomy standardizes **property names**, their **meaning**, and where they may appear, to promote interoperability.

---

## Where properties may be used

## CBOM scope and assertion semantics (normative)

## Interface binding component pattern (recommended)

To represent **hierarchical** relationships (Interface → Protocol(s) → Algorithm(s)) while remaining schema-aligned, this taxonomy RECOMMENDS modeling each interface binding as a **separate component** with a stable `bom-ref`.

- **Suggested `bom-ref` pattern:** `iface:nf:<NF_NAME>:<INTERFACE>[:<SCOPE>]`  
  Examples:
  - `iface:nf:AMF:N2` (vendor/capability)
  - `iface:nf:AMF:N2:deployed` (on-the-wire)

The interface binding component can carry the TR/TS 33.938-aligned fields (`interface`, `cryptoFunction`, `protocol`, `cryptography`, `pqcRiskLevel`) and any effective/on-the-wire fields for `deployed` scope.

The binding component SHOULD then declare dependencies on `cryptographic-asset` components that represent protocols and algorithms.

This taxonomy supports two complementary use cases:

- **Vendor CBOM (capability/supported):** what an NF product supports (vendor-supplied).
- **Deployed CBOM (effective/on-the-wire):** what is configured/used in a specific operator deployment.

To avoid ambiguity, CBOM producers SHOULD declare scope and MAY tag whether a given crypto statement is **supported** vs **effective**.

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:cbom.scope` | Declares whether the BOM is vendor capability or deployed effective posture. | enum: `vendor`, `deployed` | SHOULD appear once | `metadata` |
| `atis:telecom5g:assertion` | Qualifies a crypto statement as supported vs effective (if mixing in one BOM). Prefer using `cbom.scope`. | enum: `supported`, `effective` | MAY appear | `component` |

The **Property of** column describes where a property may be attached.

- `metadata` properties apply to the BOM as a whole.
- `component` properties apply to the component they are attached to.
- In this profile, **5G Network Functions (NFs)** are represented as `components[]`.

---

## Top-level namespace: `atis`

### Sub-namespace: `atis:telecom5g`

### Namespace description
Sub-namespace for properties describing **3GPP 5G architecture**, including **network functions**, **3GPP interfaces**, **cryptography bindings**, **trust boundaries**, and **standards traceability** for CBOMs.

### Sub-namespace overview (informative)
- `atis:telecom5g:meta:*` — profile identity and BOM-scoped metadata
- `atis:telecom5g:nf:*` — NF classification and architecture role metadata
- `atis:telecom5g:crypto:*` — NF-level crypto protocol/algorithm inventory
- `atis:telecom5g:iface.*.*` — per-interface crypto bindings (using dotted form to encode interface IDs)
- `atis:telecom5g:pki:*` — PKI / certificate usage indicators
- `atis:telecom5g:trust:*` — trust zone / boundary annotations
- `atis:telecom5g:spec:*` — standards/specification traceability (when not using externalReferences)

---

## `atis:telecom5g:meta` namespace taxonomy

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:profile` | Identifies the 5G CBOM profile and version claimed by this BOM. Example: `3gpp-5g-arch-cbom/0.1`. | string | MAY appear once | `metadata` |
| `atis:telecom5g:scenario` | Architecture scenario profile target (e.g., `TS23.501-roaming`). | string | MAY appear once | `metadata` |
| `atis:telecom5g:baselineRelease` | 3GPP baseline release assumed for the architecture model (e.g., `Rel-17`, `Rel-18`). | string | MAY appear once | `metadata` |

---

## `atis:telecom5g:nf` namespace taxonomy

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:nf.name` | Canonical NF identifier (if `component.name` is not canonical). Example: `AMF`. | string | MAY appear once | `component` |
| `atis:telecom5g:nf.type` | NF category (e.g., `SBA`, `Access`, `UserPlane`, `RoamingSecurity`). | string | MAY appear once | `component` |
| `atis:telecom5g:nf.role` | Architecture role hint (e.g., `control-plane`, `user-plane`, `security-edge`). | string | MAY appear once | `component` |
| `atis:telecom5g:interfaces` | Comma-separated list of 3GPP reference points supported/exposed by the NF. Example: `N1,N2,N11,N12`. | string | SHOULD appear once | `component` |

---

## `atis:telecom5g:crypto` namespace taxonomy (NF-level)

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:crypto.protocols` | NF-level cryptographic protocols used by the NF (coarse). Example: `TLS,IPsec,5G-AKA,PRINS`. | string | SHOULD appear once | `component` |
| `atis:telecom5g:crypto.algorithms` | NF-level cryptographic algorithms/suites used. Example: `AES-128-GCM,ECDHE,HMAC-SHA-256`. | string | SHOULD appear once | `component` |
| `atis:telecom5g:usageContext` | Coarse cryptographic usage context for the NF (when per-interface binding is not provided). Example: `signaling-protection`. | string | MAY appear multiple times | `component` |
| `atis:telecom5g:crypto.quantumReady` | Indicates whether the NF’s crypto posture is declared “quantum-ready” per the profile’s definitions. | boolean (`true`/`false`) | MAY appear once | `component` |

---

## Per-interface bindings: `atis:telecom5g:iface.<Nxx>.*`

### Effective (on-the-wire) per-interface reporting (recommended)
### Effective reporting (flat, optional)
If a producer prefers *flat* reporting on the interface binding component (in addition to dotted names), the following properties MAY be used:

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:effectiveProtocol` | Effective protocol(s) used on the wire for the interface binding. | string | MAY appear multiple times | component |
| `atis:telecom5g:effectiveCryptography` | Effective negotiated/enforced algorithms/suites used on the wire. | string | MAY appear multiple times | component |


When producing a **deployed** CBOM, producers SHOULD report the *effective* configuration/negotiated posture per interface. If needed, the following optional properties may be used:

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:iface.<Nxx>.effectiveProtocol` | Effective protocol used on the wire for this interface. Example: `TLS 1.3`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.effectiveCryptography` | Effective negotiated/enforced algorithms/suites on the wire. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.cert.keyType` | Certificate public key type used (if TLS/mTLS). Example: `RSA`, `ECDSA`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.cert.keyLength` | Certificate key length in bits (RSA) or equivalent. Example: `2048`. | integer or string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.cert.curve` | Certificate curve identifier (ECC). Example: `P-256`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.cert.validation` | Validation mechanism used. Example: `OCSP`, `CRL`. | string | MAY appear once per interface | `component` |

This taxonomy uses **dotted interface identifiers** to avoid defining a separate object type.
- `<Nxx>` MUST be a 3GPP interface identifier (e.g., `N1`, `N2`, `N11`, `N12`, `N32`, etc.).
- Properties below MAY be repeated for different interfaces per component.

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:iface.<Nxx>.protocol` | Protocol protecting this interface. Example: `TLS1.3` or `IPsec`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.algorithms` | Algorithms/suites for this interface. Example: `AES-128-GCM,ECDHE`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.usageContext` | Security purpose for this interface. Example: `authn-key-agreement`, `signaling-confidentiality`, `roaming-protection`. | string | MAY appear once per interface | `component` |
| `atis:telecom5g:iface.<Nxx>.standardRefs` | Standards supporting this binding. Example: `3GPP TS 33.501; 3GPP TS 29.xxx`. | string | MAY appear once per interface | `component` |

---

## `atis:telecom5g:pki` namespace taxonomy

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:pki.usage` | Whether PKI/X.509 certs are used for this NF (e.g., for TLS/mTLS). | boolean | MAY appear once | `component` |
| `atis:telecom5g:pki.role` | PKI role. Example: `client`, `server`, `mutual`. | string | MAY appear once | `component` |
| `atis:telecom5g:pki.trustAnchor` | Trust anchor identifier. Example: `operatorCA`, `interPLMNCA`. | string | MAY appear once | `component` |

---

## `atis:telecom5g:trust` namespace taxonomy

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:trust.domain` | Trust domain/zone classification. Example: `access`, `core`, `inter-PLMN`. | string | MAY appear once | `component` |
| `atis:telecom5g:trust.boundary` | Indicates whether the NF sits at a trust boundary. Example: `true` for SEPP in roaming scenarios. | boolean | MAY appear once | `component` |

---

## `atis:telecom5g:spec` namespace taxonomy (optional)

Prefer CycloneDX `externalReferences[]` for standards citations. Use these properties when a vendor cannot provide structured external references.

| Property | Description | Value type | Cardinality | Property of |
|---|---|---:|---:|---|
| `atis:telecom5g:spec.primary` | Primary 3GPP specification driving this NF’s security behavior. Example: `TS 33.501`. | string | MAY appear once | `component` |
| `atis:telecom5g:spec.crypto` | Crypto-specific specification references. Example: `TS 35.206; TS 35.221`. | string | MAY appear multiple times | `component` |

---

## TR/TS 33.938-aligned field set (normative for this taxonomy)

The following properties align to a 3GPP cryptographic-inventory field set (TR/TS 33.938-style) for 5G infrastructure. They are designed to be usable with CycloneDX `properties` while remaining vendor-neutral and interoperable.

### Entity (Network Function)
- **CycloneDX mapping:** `component.name`
- **Rule:** SHOULD appear once per NF component (the component itself is the NF)
- **Naming convention (canonical examples):** `AMF`, `SMF`, `UPF`, `AUSF`, `UDM`, `UDR`, `PCF`, `NRF`, `NSSF`, `NEF`, `AF`, `BSF`, `CHF`, `NWDAF`, `SEPP`, `N3IWF`, `gNB-CU`, `gNB-DU`.

### Reference Interface
- **CycloneDX mapping:** `component.properties[name="atis:telecom5g:interface"]`
- **Rule:** SHOULD appear once per interface binding (see per-interface binding guidance below)
- **Naming convention (canonical examples):** `N1`, `N2`, `N3`, `N4`, `N6`, `N9`, `N11`, `N12`, `N15`, `N22`, `N32`, `Nnrf`, `Npcf`, `Nnef`, `Nbsf`, `Nudm`, `Nudr`, `Nnwdaf`, `Xn`, `F1`, `E1`.

### Crypto Function
- **CycloneDX mapping:** `component.properties[name="atis:telecom5g:cryptoFunction"]`
- **Rule:** MAY appear once per interface binding (repeatable if multiple protocols are used)
- **Controlled vocabulary:** `Authentication`, `Integrity`, `Confidentiality`, `ChannelProtection-CP`, `ChannelProtection-UP`, `APIProtection`, `KeyManagement`.

### Protocol
- **CycloneDX mapping:** `component.properties[name="atis:telecom5g:protocol"]`
- **Rule:** MAY appear once per interface binding (repeatable if multiple protocols are used)
- **Naming convention (canonical examples):** `5G-AKA`, `EAP-AKA'`, `TLS 1.3`, `IPsec/IKEv2`, `PRINS`, `DTLS 1.3`, `PDCP Security`, `X.509 PKI`, `OCSP`.

### Cryptography (Algorithms / Suites / Primitives)
- **CycloneDX mapping:** `component.properties[name="atis:telecom5g:cryptography"]`
- **Rule:** MAY appear once per interface binding (repeatable if multiple protocols are used)
- **Naming convention (canonical examples):** `AES-128-GCM`, `HMAC-SHA-256`, `RSA-2048`, `ECDHE P-256`, `ECDSA P-256`, `128-NEA1`, `128-NIA2`, `MILENAGE`, `TUAK`.

### PQC Risk Level
- **CycloneDX mapping:** `component.properties[name="atis:telecom5g:pqcRiskLevel"]`
- **Rule:** SHOULD appear once per NF component (or once per interface binding if assessed at interface granularity)
- **Enum values:** `High` (RSA/ECC used), `Medium` (hybrid), `Low` (symmetric/PQC-ready).

### Per-interface binding guidance (recommended)
Because CycloneDX `properties` are name/value pairs, to represent multiple interfaces per NF without ambiguity, this taxonomy RECOMMENDS using a per-interface prefix:

- `atis:telecom5g:iface.<Interface>.cryptoFunction`
- `atis:telecom5g:iface.<Interface>.protocol`
- `atis:telecom5g:iface.<Interface>.cryptography`
- `atis:telecom5g:iface.<Interface>.pqcRiskLevel`

Example:
- `atis:telecom5g:iface.N12.cryptoFunction = Authentication`
- `atis:telecom5g:iface.N12.protocol = TLS 1.3`
- `atis:telecom5g:iface.N12.cryptography = AES-128-GCM,ECDHE P-256`
- `atis:telecom5g:iface.N12.pqcRiskLevel = High`

### Optional completeness fields (commonly needed in cryptographic inventories)
CBOM inventories often require metadata such as algorithm variants, key lengths, protocol configuration, and certificate attributes. This taxonomy defines optional properties for these fields.

| Property | Description | Value type | Property of |
|---|---|---:|---|
| `atis:telecom5g:cryptoType` | Cryptography category used by the protocol/binding. Examples: `symmetric`, `asymmetric`, `hybrid`. | string | component |
| `atis:telecom5g:keyLength` | Key size in bits where applicable. Examples: `128`, `256`, `2048`. | integer or string | component |
| `atis:telecom5g:curve` | Elliptic curve identifier when applicable. Examples: `P-256`, `P-384`. | string | component |
| `atis:telecom5g:cert.profile` | Certificate profile identifier/reference when applicable (e.g., operator profile). | string | component |
| `atis:telecom5g:cert.validation` | Certificate validation mechanism. Examples: `OCSP`, `CRL`. | string | component |

## Non-`atis:telecom5g` legacy property names (informative mapping)

Some implementations may already use ad-hoc names (e.g., in prototypes). This profile RECOMMENDS migrating to `atis:telecom5g:*`.

| Legacy property | Recommended replacement |
|---|---|
| `3gpp:function` | `atis:telecom5g:nf.name` (or canonical `component.name`) |
| `interfaces` | `atis:telecom5g:interfaces` |
| `crypto:protocols` | `atis:telecom5g:crypto.protocols` |
| `crypto:algorithms` | `atis:telecom5g:crypto.algorithms` |
| `pki:usage` | `atis:telecom5g:pki.usage` |
| `security:usage` | `atis:telecom5g:usageContext` (or per-interface usageContext) |
