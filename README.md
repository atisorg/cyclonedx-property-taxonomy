# ATIS CBOM Standard for Telecom 
# cyclonedx-property-taxonomy
The official CycloneDX property taxonomy for ATIS CBOM for Telecom ..

For more information on the CycloneDX property taxonomies, refer to their [documentation](https://github.com/CycloneDX/cyclonedx-property-taxonomy).

# atis:telecom5g — CycloneDX Property Taxonomy


# Description

The atis:telecom5g Property Taxonomy defines a standardized set of CycloneDX property names for representing 3GPP 5G architecture and security/cryptography metadata in CycloneDX BOMs (with a focus on CBOM use cases). It provides consistent, interoperable naming for:

5G Network Functions (NFs) and their roles

3GPP reference interfaces (e.g., N1–N32) and per-interface security bindings

Cryptographic protocols, algorithms, and suites (including 3GPP-specific mechanisms where needed)

Trust boundaries and PKI/certificate usage indicators

Standards traceability back to relevant 3GPP specifications

This taxonomy is intended to be used alongside a CycloneDX profile (e.g., a “3GPP 5G Architecture CBOM Profile for CycloneDX 1.7”) that defines the conformance rules (MUST/SHOULD) for vendors producing CBOMs for 5G infrastructure.

# Scope

This taxonomy applies to 3GPP 5G infrastructure and related deployments, including (but not limited to):

5G Core (5GC) network functions such as AMF, SMF, UPF, AUSF, UDM, PCF, NRF, NSSF, NEF, SEPP, etc.

5G Access components such as UE and (R)AN, where relevant to security and cryptographic inventory

3GPP-defined reference points and service-based interfaces (e.g., N1, N2, N3, N4, N6, N9, N11, N12, N14, N15, N22, N32)

Roaming and inter-PLMN security scenarios (e.g., SEPP/N32 protections)

# In scope

Naming conventions for properties that capture interface-level crypto protections

NF-level crypto declarations where interface-level detail is not available

Indicators for PKI usage, trust anchors, and trust domains/zones

References to 3GPP specifications governing cryptographic behavior

# Out of scope

Defining or changing the CycloneDX base schema

Replacing authoritative 3GPP requirements; this taxonomy only provides metadata conventions

Product/vendor-specific implementation details not needed for interoperability

Non-3GPP telecom domains (unless explicitly added via additional ATIS sub-taxonomies)

If you want, I can also add a short “Audience / Intended Use” paragraph (vendors, operators, regulators, auditors) and a “Compatibility” section that states it’s intended for CycloneDX 1.7 CBOM/cryptography work and works with any format that supports CycloneDX properties.
