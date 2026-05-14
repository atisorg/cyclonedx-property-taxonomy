# 3GPP 5G Architecture CBOM Profile for CycloneDX 1.7 (Draft v0.6)

## 1. Scope
This profile defines **minimum, interoperable expectations** for a **Cryptographic Bill of Materials (CBOM)** representing a **3GPP 5G system architecture** (e.g., TS 23.501 roaming reference architecture).  
It is a **profile of the CycloneDX 1.7 specification**, not a replacement schema.

## 2. Conformance keywords
The key words **MUST**, **MUST NOT**, **SHOULD**, **MAY** are to be interpreted as in RFC 2119.

## 3. Base standard and formats
- BOMs **MUST** validate against the official **CycloneDX 1.7** schema for the chosen serialization (JSON/XML/Protobuf).
- This profile defines **additional constraints** and **required content conventions**.

## 4. Profile identification
A BOM claiming conformance **MUST** include:
- `bomFormat = "CycloneDX"`
- `specVersion = "1.7"`
- A profile marker in `metadata.properties[]`:
  - `name: "atis:telecom5g:profile"`
  - `value: "3gpp-5g-arch-cbom/0.6"`

In addition, the BOM **SHOULD** declare its scope in `metadata.properties[]`:
- `name: "atis:telecom5g:cbom.scope"`
- `value: "vendor"` (capability/supported) **or** `value: "deployed"` (effective/on-the-wire)


## 4.1 Vendor vs deployed CBOM semantics (normative)
This profile supports two scopes:

### Vendor CBOM (`atis:telecom5g:cbom.scope = vendor`)
A vendor CBOM describes **what the NF product supports** (capability), independent of operator PKI/certificates and runtime policy.

Vendor CBOMs:
- **SHOULD** include supported protocol/crypto sets (capability), e.g.:
  - `atis:telecom5g:crypto.supportedProtocols`
  - `atis:telecom5g:crypto.supportedCryptography`
- **MAY** omit certificate-derived details (issuer/subject/key parameters), because these are often provisioned externally by the operator PKI.

### Deployed CBOM (`atis:telecom5g:cbom.scope = deployed`)
A deployed CBOM describes **what is configured/used on the wire** in a specific deployment (effective posture). Certificate-derived parameters are in scope here.

Deployed CBOMs:
- **SHOULD** include per-interface effective posture, e.g.:
  - `atis:telecom5g:iface.<Interface>.effectiveProtocol`
  - `atis:telecom5g:iface.<Interface>.effectiveCryptography`
- When TLS/mTLS is used, deployed CBOMs **SHOULD** include certificate public key parameters per interface:
  - `atis:telecom5g:iface.<Interface>.cert.keyType`
  - `atis:telecom5g:iface.<Interface>.cert.keyLength` (RSA) and/or `atis:telecom5g:iface.<Interface>.cert.curve` (ECC)
  - `atis:telecom5g:iface.<Interface>.cert.validation` (e.g., OCSP/CRL)


## 5. Modeling approach (normative choices)
### 5.1 Representing Network Functions (NFs)
- Each 5G Network Function (NF) **MUST** be represented as a CycloneDX `component` of:
  - `type = "service"` **OR** `type = "application"`.
- Implementers **SHOULD** use:
  - `type = "service"` for Service-Based Architecture (SBA) NFs (e.g., AMF, SMF, PCF, NRF, UDM, AUSF, NSSF, NEF)
  - `type = "device"` for UE and (R)AN where appropriate.

### 5.2 NF identity
Each NF component **MUST** include:
- `name`: canonical 3GPP NF identifier (e.g., `AMF`, `SMF`, `UPF`, `SEPP`, `NRF`, `UDM`, `AUSF`, `PCF`, `NEF`, `NSSF`, `NSSAF`, `NSSAAF`, `AF`, `UE`, `(R)AN`)
- `bom-ref`: stable identifier (recommended format: `nf:<NF_NAME>:<OPTIONAL_INSTANCE>`)

### 5.3 Interfaces (3GPP reference points)
Each NF component **MUST** declare its reference interfaces via properties:
- `atis:telecom5g:interfaces` = comma-separated list of `N*` interfaces (e.g., `N1,N2,N11,N12`)
- If per-interface crypto is provided (recommended), it **MUST** use the per-interface structure in §6.

## 6. Cryptography binding (core of CBOM)
This profile requires that cryptography is expressible:
- at the NF level (minimum)
- and preferably at the **interface level** (recommended)

### 6.1 Minimum cryptography (NF-level)
Each NF component **MUST** include at least:
- `atis:telecom5g:crypto.protocols` (e.g., `TLS`, `IPsec`, `PRINS`, `5G-AKA`)
- `atis:telecom5g:crypto.algorithms` (e.g., `AES-128-GCM`, `HMAC-SHA-256`, `ECDHE`, `ZUC`, `SNOW3G`, `MILENAGE`)

### 6.2 Recommended cryptography (interface-level)
For each interface `Nx`, implementers **SHOULD** include one or more **interface crypto bindings** as properties using a structured naming convention:

- `atis:telecom5g:iface.<Nx>.protocol` (e.g., `atis:telecom5g:iface.N11.protocol = TLS1.3`)
- `atis:telecom5g:iface.<Nx>.algorithms` (e.g., `atis:telecom5g:iface.N11.algorithms = AES-128-GCM,ECDHE`)
- `atis:telecom5g:iface.<Nx>.usageContext` (e.g., `signaling-auth`, `signaling-confidentiality`, `roaming-protection`)
- `atis:telecom5g:iface.<Nx>.standardRefs` (e.g., `3GPP TS 33.501; 3GPP TS 29.xxx`)

### 6.3 TR/TS 33.938-aligned interface binding fields (normative)
To support 3GPP cryptographic inventory reporting (TR/TS 33.938-style), each NF MAY provide one or more interface bindings using the following properties. For vendor CBOMs these properties typically represent **supported** capability; for deployed CBOMs they represent **effective/on-the-wire** posture.

- **Entity (NF):** `component.name` SHOULD be the canonical NF acronym (e.g., `AMF`, `SMF`, `UPF`, `AUSF`, `UDM`, `UDR`, `PCF`, `NRF`, `NSSF`, `NEF`, `AF`, `BSF`, `CHF`, `NWDAF`, `SEPP`, `N3IWF`, `gNB-CU`, `gNB-DU`).
- **Reference Interface:** `properties[name="atis:telecom5g:interface"]` SHOULD appear once per interface binding, using canonical labels (e.g., `N1`, `N2`, `N3`, `N4`, `N6`, `N9`, `N11`, `N12`, `N15`, `N22`, `N32`, `Nnrf`, `Npcf`, `Nnef`, `Nbsf`, `Nudm`, `Nudr`, `Nnwdaf`, `Xn`, `F1`, `E1`).

For each interface binding, an NF MAY include:
- `atis:telecom5g:cryptoFunction` (Controlled vocabulary: `Authentication`, `Integrity`, `Confidentiality`, `ChannelProtection-CP`, `ChannelProtection-UP`, `APIProtection`, `KeyManagement`)
- `atis:telecom5g:protocol` (Examples: `5G-AKA`, `EAP-AKA'`, `TLS 1.3`, `IPsec/IKEv2`, `PRINS`, `DTLS 1.3`, `PDCP Security`, `X.509 PKI`, `OCSP`)
- `atis:telecom5g:cryptography` (Examples: `AES-128-GCM`, `HMAC-SHA-256`, `RSA-2048`, `ECDHE P-256`, `ECDSA P-256`, `128-NEA1`, `128-NIA2`, `MILENAGE`, `TUAK`)
- `atis:telecom5g:pqcRiskLevel` (Enum: `High`, `Medium`, `Low`)

If an NF reports multiple interfaces, implementations SHOULD use the per-interface dotted form:
- `atis:telecom5g:iface.<Interface>.cryptoFunction`
- `atis:telecom5g:iface.<Interface>.protocol`
- `atis:telecom5g:iface.<Interface>.cryptography`
- `atis:telecom5g:iface.<Interface>.pqcRiskLevel`


## 6.4 Hierarchical CBOM modeling for interfaces (normative)
To represent **Interface → Protocol(s) → Algorithm(s)** in a schema-aligned way, producers **SHOULD**:

1. Represent each 3GPP interface binding as a **separate component** (the “interface binding component”), with a stable `bom-ref`, e.g.:
   - `iface:nf:AMF:N2` (vendor)
   - `iface:nf:AMF:N2:deployed` (deployed)

2. Represent protocols and algorithms as CycloneDX CBOM **cryptographic assets**:
   - `components[].type = "cryptographic-asset"`
   - `cryptoProperties.assetType = "protocol"` for protocol assets
   - `cryptoProperties.assetType = "algorithm"` for algorithm assets

3. Link hierarchy using `dependencies[]`:
   - NF component depends on the interface binding component
   - Interface binding component depends on one or more protocol assets
   - Protocol assets reference algorithm assets via `protocolProperties.cipherSuites[].algorithms[]` (by `bom-ref`)

This approach avoids flattening all crypto onto the NF while enabling complete per-interface reporting.


## 6.5 TR/TS 33.938-scoped properties (normative)

To support TR/TS 33.938-aligned CBOMs and SCAS-driven assessment workflows, CBOM producers MAY use the following additional properties. When used, they MUST follow the controlled values in the taxonomy:

- **Entity scope / conformance context**
  - `atis:telecom5g:nfType` (TR/TS 33.938 entity set)
  - `atis:telecom5g:3gppSpecRelease` (Rel-15/16/17/18/19)

- **NAS algorithm identifiers (TS 33.501 short-form)**
  - `atis:telecom5g:nasIntegrityAlgorithm` = `NIA0|NIA1|NIA2|NIA3`
  - `atis:telecom5g:nasConfidentialityAlgorithm` = `NEA0|NEA1|NEA2|NEA3`

- **User-plane integrity algorithm (if UP integrity is used)**
  - `atis:telecom5g:upIntegrityAlgorithm` = `NIA1|NIA2|NIA3`

- **SBI mutual authentication**
  - `atis:telecom5g:sbi.mutualAuthentication` (boolean)
  - `atis:telecom5g:mTLSRequired` MAY be used as an alias

- **SUCI protection scheme (UDM/ARPF)**
  - `atis:telecom5g:suciProtectionScheme` = `null-scheme|profile-a|profile-b`

- **OAuth authorization (SBI)**
  - `atis:telecom5g:oauthTokenType` (expected `JWT`)
  - `atis:telecom5g:oauthTokenProtection` (`signature` or `mac`)

- **Key derivation function (BOM-wide)**
  - `atis:telecom5g:kdfAlgorithm` (expected `HMAC-SHA-256`) SHOULD be declared in `metadata.properties[]`.


## 7. Trust boundaries and PKI
Where applicable (notably SBA and inter-PLMN):
- NFs using X.509/PKI for TLS/mTLS **MUST** state:
  - `atis:telecom5g:pki.usage = true|false`
- If `true`, implementers **SHOULD** provide:
  - `atis:telecom5g:pki.role` (e.g., `client`, `server`, `mutual`)
  - `atis:telecom5g:pki.trustAnchor` (e.g., `operatorCA`, `inter-PLMN trust anchor`)

## 8. Standards and traceability
Cryptographic mechanisms **SHOULD** be traceable to authoritative standards:
- Components **SHOULD** include `externalReferences[]` entries for relevant 3GPP specs (e.g., TS 23.501, TS 33.501, TS 35.xxx).
- For per-interface bindings, implementers **SHOULD** use `atis:telecom5g:iface.<Nx>.standardRefs`.

## 9. Dependencies (NF-to-NF)
- The BOM **MUST** include `dependencies[]` that capture the NF interaction graph at least at the NF level.
- Dependencies **SHOULD** align with the declared interfaces (e.g., AMF depends on AUSF over N12).

## 10. Namespace and property names
### 10.1 Namespace proposal
This profile uses the registered ATIS top-level namespace with sub-namespace: **`atis:telecom5g`**.

### 10.2 Canonical property names (initial set)
- `atis:telecom5g:profile`
- `atis:telecom5g:nf` (optional if `name` is canonical)
- `atis:telecom5g:interfaces`
- `atis:telecom5g:crypto.protocols`
- `atis:telecom5g:crypto.algorithms`
- `atis:telecom5g:usageContext`
- `atis:telecom5g:pki.usage`
- `atis:telecom5g:pki.role`
- `atis:telecom5g:pki.trustAnchor`
- `atis:telecom5g:trust.domain` (e.g., `access`, `core`, `inter-PLMN`)
- `atis:telecom5g:iface.<Nx>.protocol`
- `atis:telecom5g:iface.<Nx>.algorithms`
- `atis:telecom5g:iface.<Nx>.usageContext`
- `atis:telecom5g:iface.<Nx>.standardRefs`

## 11. Profile maturity alignment (non-normative)
This profile can be assessed using a maturity model (e.g., SCVS BOM maturity concepts):
- Level 1: NF inventory + NF-level crypto
- Level 2: Interfaces captured + partial interface-level crypto
- Level 3: Complete interface-level crypto + dependencies + traceability
- Level 4: Level 3 + post-quantum readiness metadata

## Appendix A — Minimal example (AMF, excerpt)
```json
{
  "type": "service",
  "name": "AMF",
  "bom-ref": "nf:AMF",
  "properties": [
    { "name": "atis:telecom5g:interfaces", "value": "N1,N2,N11,N12,N14,N15,N22" },

    { "name": "atis:telecom5g:interface", "value": "N12" },
    { "name": "atis:telecom5g:cryptoFunction", "value": "Authentication" },
    { "name": "atis:telecom5g:protocol", "value": "TLS 1.3" },
    { "name": "atis:telecom5g:cryptography", "value": "AES-128-GCM,ECDHE P-256" },
    { "name": "atis:telecom5g:pqcRiskLevel", "value": "High" },

    { "name": "atis:telecom5g:pki.usage", "value": "true" },

    { "name": "atis:telecom5g:iface.N12.cryptoFunction", "value": "Authentication" },
    { "name": "atis:telecom5g:iface.N12.protocol", "value": "TLS 1.3" },
    { "name": "atis:telecom5g:iface.N12.cryptography", "value": "AES-128-GCM,ECDHE P-256" },
    { "name": "atis:telecom5g:iface.N12.pqcRiskLevel", "value": "High" }
  ]
}
```

## Appendix B — N2 interface minimum reporting (normative)

This appendix defines the minimum set of information expected when a CBOM includes the **AMF N2** interface.

### B.1 Vendor CBOM (capability) for N2
An AMF vendor CBOM that includes N2:

- **MUST** include an AMF component (`component.name = "AMF"`) and an interface binding component (`bom-ref` pattern `iface:nf:AMF:N2`).
- The interface binding component **SHOULD** include:
  - `atis:telecom5g:interface = N2`
  - `atis:telecom5g:cryptoFunction = ChannelProtection-CP`
  - One or more `atis:telecom5g:protocol` entries (e.g., `DTLS 1.3`, `IKEv2`, `IPsec ESP`) describing **supported** protocol mechanisms for N2.
  - One or more `atis:telecom5g:cryptography` entries describing supported algorithms/suites/primitives.
  - `atis:telecom5g:pqcRiskLevel`

- The interface binding component **SHOULD** depend on protocol `cryptographic-asset` components, which in turn reference algorithm `cryptographic-asset` components.

### B.2 Deployed CBOM (on-the-wire) for N2
A deployed CBOM that includes AMF N2:

- **MUST** set `atis:telecom5g:cbom.scope = deployed`.
- **MUST** include an interface binding component with `bom-ref` pattern `iface:nf:AMF:N2:deployed`.
- The interface binding component **SHOULD** include:
  - `atis:telecom5g:iface.N2.effectiveProtocol`
  - `atis:telecom5g:iface.N2.effectiveCryptography`
  - `atis:telecom5g:pqcRiskLevel`
- If certificate-based authentication is used for the protection mechanism, the binding component **SHOULD** include:
  - `atis:telecom5g:iface.N2.cert.keyType` and (`atis:telecom5g:iface.N2.cert.keyLength` for RSA and/or `atis:telecom5g:iface.N2.cert.curve` for ECC)
  - `atis:telecom5g:iface.N2.cert.validation` (e.g., OCSP/CRL)

- The interface binding component **SHOULD** depend on the effective protocol assets and their referenced algorithm assets.

## Appendix C — SEPP N32-c / N32-f reporting (normative)

When modeling SEPP roaming security, producers SHOULD distinguish between:

- `N32-c` (control-plane negotiation channel; TLS-based)
- `N32-f` (forwarding plane / application-layer protection; PRINS-based)

A CBOM that includes SEPP roaming SHOULD:
- represent `iface:nf:SEPP:N32-c` and `iface:nf:SEPP:N32-f` as separate interface binding components; and
- report distinct `protocol` / `cryptography` sets (and effective posture for deployed CBOMs) for each binding.

