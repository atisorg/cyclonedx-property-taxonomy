# **Guide to Using and Implementing the**
ATIS Telecom 5G CBOM Property Taxonomy

Implementation-oriented guidance for applying the ATIS `atis:telecom5g` property taxonomy
with CycloneDX CBOMs for 3GPP 5G security architecture



|  |
| --- |
| This guide explains how to use the ATIS Telecom 5G CBOM Property Taxonomy in practice. It does not restate the taxonomy line by line. Property names, allowed placements, and evolving examples should be taken from the current ATIS GitHub release. |



# **Draft implementation guide v0.6**

Prepared for working use and review



## **Summary**

The ATIS Telecom 5G CBOM Property Taxonomy provides a 5G-specific property layer for describing 3GPP 5G architecture, network functions, interfaces, cryptographic posture, trust boundaries, and related standards traceability within a CycloneDX CBOM. This guide explains how to apply that taxonomy to real implementation work. It is intended for teams that need to produce, validate, exchange, and consume 5G CBOMs in a consistent way across vendor and operator environments.

The guide is intentionally implementation-focused. The authoritative current definition of the taxonomy remains the ATIS GitHub publication. Implementers should use the GitHub version for the current release, current property set, and current examples. This document adds process guidance: how to define CBOM scope, how to represent a 5G architecture boundary, how to distinguish vendor capability from deployed effective posture, how to organize validation, and how to use the resulting CBOM for security and migration activities.

The document draws on three foundations. First, the ATIS taxonomy provides the 5G profile structure and the 5G-specific namespaces and recommended modeling patterns. Second, the CycloneDX CBOM guide provides the general CBOM model for cryptographic assets, dependencies, and automation. Third, the IBM one-sheet highlights the operational value of CBOMs for cryptographic inventory, weak-crypto discovery, policy assessment, and quantum-readiness planning.

## **1. References**

The following references should be used with this guide. Normative references define the basis of implementation. Informative references provide context, rationale, and supporting practices.

| Type | Reference | Purpose in this guide |
| --- | --- | --- |
| Normative | ATIS Telecom 5G CBOM Property Taxonomy on GitHub | Live authoritative source for the current `atis:telecom5g` release, property names, usage locations, and examples. |
| Normative | CycloneDX v1.7 | Base object model and syntax for the BOM that carries the 5G taxonomy properties. |
| Normative | 3GPP TR/TS 33.938 cryptographic inventory concepts | Reference basis for the architecture and crypto-inventory alignment used by the taxonomy. |
| Informative | OWASP CycloneDX Authoritative Guide to CBOM | General CBOM design principles, asset categories, dependency semantics, and operational use cases. |
| Normative | ATIS telecom5g validation artifacts (overlay schema, taxonomy JSON, helper scripts) | Machine-readable validation package hosted alongside the taxonomy to support CycloneDX 1.7 schema validation and ATIS telecom5g property conformance checks. |

This guide should always be read together with the ATIS GitHub taxonomy. When there is any difference between this implementation guidance and the latest taxonomy publication, the current GitHub taxonomy release should be treated as the source of truth for property definitions and examples.

## **2. Scope and Intended Audience**

This guide is scoped to the use of the ATIS Telecom 5G CBOM Property Taxonomy for a 3GPP 5G security architecture CBOM. Its purpose is to help implementers apply the taxonomy in a practical, repeatable way. The guide is not a restatement of the full taxonomy and it is not a replacement for CycloneDX or 3GPP source specifications.

The primary audiences are:

5G vendors preparing capability-oriented CBOMs for products, functions, or platform components.

Mobile network operators preparing deployment-specific CBOMs that describe effective cryptographic posture in a live environment.

Security architects and product owners who need a structured inventory of cryptographic usage across a 5G architecture.

Tooling teams building authoring, validation, or ingestion pipelines for telecom-focused CBOMs.

Assurance, procurement, and compliance teams that need a machine-readable input for review and policy checks.

The following items are in scope:

Application of the ATIS taxonomy to 5G network functions, interfaces, cryptographic protocols, algorithms, PKI usage, trust boundaries, and standards traceability.

Use of CycloneDX components, properties, and dependencies to carry the 5G CBOM information.

Implementation workflow for authoring, validating, publishing, and consuming a 5G CBOM.

Guidance on vendor-scope and deployed-scope CBOM production.

The following items are out of scope:

Republishing the full property catalog from the ATIS GitHub taxonomy.

Defining a new validator specification or a new schema independent of CycloneDX.

Providing a library of full examples in this document; examples should be maintained on the ATIS GitHub with the live taxonomy release.

## **3. How to Use This Guide with the ATIS GitHub Taxonomy**

The ATIS GitHub taxonomy and this guide play different roles. The taxonomy defines the property namespace, the property names, where each property may be attached, and the recommended modeling patterns. This guide explains how to use those capabilities in an implementation program.

A practical reading order is:

1. Read the current ATIS GitHub taxonomy release to understand the property set and current examples.

2. Use this guide to decide scope, authoring approach, validation workflow, and publication practices.

3. Return to the taxonomy during implementation whenever a specific property choice, property location, or example is needed.



| Implementation rule |
| --- |
| Do not copy the taxonomy into local project documents and then treat the copied version as authoritative. Instead, reference the ATIS GitHub release and keep local implementation material focused on process, governance, and usage. |



### **3.4. ATIS GitHub artifacts and folder layout (outline)**

The ATIS GitHub repository hosts the normative taxonomy and the supporting validation and example artifacts. Implementers should reference the current release for the authoritative versions of these files.

| Artifact | GitHub location | Purpose | Notes |
| --- | --- | --- | --- |
| Property taxonomy (normative) | atis-telecom5g-property-taxonomy-v0.6.md (root) | Authoritative property names, placement rules, and vocabularies. | Source of truth for atis:telecom5g properties. |
| CBOM profile specification (normative) | 3GPP_5G_CBOM_Profile_CycloneDX1.7_v0.6*.md (root) | Profile guidance for using CycloneDX 1.7 with the ATIS telecom5g taxonomy. | Includes vendor vs deployed semantics and cross-BOM linkage guidance. |
| Machine-readable taxonomy extract | atis-telecom5g-taxonomy-0.6.json (root) | Tooling-friendly representation of taxonomy constraints. | Used to generate/drive validators and linters. |
| Generic overlay validator (taxonomy conformance) | Validator/atis-telecom5g-profile-0.6.schema.json | Validates CycloneDX 1.7 schema plus atis:telecom5g property name/value conformance. | Intended for CI and intake validation. |
| Validation scripts and README | Validator/ (README-validation.md, validate-cbom.ps1, validate-cbom.sh) | Outline usage steps and provide simple automation hooks. | Examples show how to run CycloneDX schema validation and ATIS overlay validation. |
| Example CBOMs | 5G CBOM examples/ (subfolder) | Reference CBOM examples for common 5G cases and patterns. | Maintained as examples rather than normative requirements. |
| Scenario-specific validators (optional) | Validator/ (subfolder) | Additional strict validators for specific scenarios (e.g., roaming SEPP). | Optional modules; not required for generic conformance. |

## **4. 5G CBOM Fundamentals in CycloneDX**

A CBOM is an object model for describing cryptographic assets and their dependencies. In CycloneDX, CBOM support is native and may be embedded in a broader BOM or externalized as a separate CBOM. The practical value of this model is that cryptographic assets can be represented in the same machine-readable ecosystem as software and system components, while still preserving cryptography-specific detail such as algorithms, protocols, certificates, keys, and dependency usage.

For telecom implementation, this matters because cryptography is rarely isolated in one module. It appears across network functions, service-based interfaces, transport protection layers, PKI dependencies, and operational configurations. A 5G CBOM therefore needs two forms of structure at the same time: an architectural view of where cryptography sits, and a cryptographic view of what is being provided or used.

CycloneDX dependencies are especially important. A 5G CBOM can describe not only that an asset exists, but also which component provides it and which function or interface uses it. That distinction is central to telecom analysis. For example, a protocol implementation may be present in a library or platform component even when it is not the effective protocol in use on a given interface.

This guide assumes that implementers use the CycloneDX base model as the carrier and the ATIS taxonomy as the 5G-specific extension layer. The result is not a separate syntax. It is a profile-driven use of existing CycloneDX capabilities.

## **5. 5G CBOM Implementation Model**

A useful 5G CBOM begins with an architecture boundary rather than a property list. The first task is to define what the BOM is intended to represent: a product capability statement, a deployment posture statement, a single network function, a service chain, or a broader architecture scenario such as roaming.

Once the system boundary is defined, the implementation model should identify the 5G network functions in scope, the relevant 3GPP reference points, the cryptographic protections associated with those reference points, and any trust boundaries or standards traceability needed for later analysis.

The ATIS taxonomy supports this model by separating BOM-scoped metadata from component-scoped properties and by recommending explicit handling of interfaces, protocols, algorithms, PKI indicators, and trust metadata. This allows an implementer to move from a high-level inventory to a more precise description without changing the basic authoring method.

| Implementation step | Question to answer | Resulting CBOM output |
| --- | --- | --- |
| Define scope | What system, product, function, or deployment is being represented? | BOM-level identity, scope declaration, scenario, and baseline release. |
| Identify entities | Which network functions and supporting components are in scope? | CycloneDX components representing NFs and related elements. |
| Identify interfaces | Which 3GPP reference points are exposed or used? | Interface lists and, where needed, interface-binding components. |
| Identify crypto posture | Which protocols, algorithms, suites, certificates, or trust anchors are relevant? | NF-level or interface-level cryptographic properties and dependencies. |
| Assess operational context | Is the CBOM vendor-supported capability or deployed effective posture? | Scope tagging and assertion clarity. |
| Validate and publish | Is the result structurally sound and fit for exchange? | Validated CBOM ready for review, exchange, or ingestion. |



## **6. Applying the Taxonomy: Core Modeling Patterns**

The most effective way to apply the taxonomy is to think in modeling patterns rather than individual properties. An implementation team should know what kind of statement it is trying to make and then select the appropriate taxonomy pattern.

### **6.1. BOM-level profile and scenario metadata**

BOM-level metadata should identify the profile claim, the architecture scenario where relevant, the assumed 3GPP baseline release, and whether the CBOM represents vendor capability or deployed posture. This is what makes the document interpretable before a consumer reads any network function detail.

### **6.2. Network function representation**

Each 5G network function in scope should be represented as a CycloneDX component. The component identity should be clear and stable enough to support later dependency and interface references. Where the canonical network function name is not obvious from the component name, the NF-specific taxonomy fields should be used to preserve canonical naming and architecture role context.

### **6.3. Coarse NF-level crypto inventory**

A coarse NF-level inventory is useful when the goal is to declare the general cryptographic profile of a network function without yet enumerating each interface binding. This is usually the right starting point for first-generation vendor CBOMs, because it provides a usable inventory quickly and supports later refinement.

### **6.4. Interface-binding modeling**

When the cryptographic posture must be attributed to specific reference points, the recommended pattern is to model each interface binding as a separate component with a stable `bom-ref`. This allows the CBOM to represent Interface → Protocol → Algorithm relationships in a schema-aligned way and avoids ambiguity when a network function uses different protections on different interfaces.

Interface-binding modeling is especially valuable for 5G because many security and migration questions are not answered at the network-function level alone. Teams often need to know what is protected on N2, N12, N32, inter-PLMN links, or other reference points, and whether the statement refers to capability or effective use.

### **6.5. PKI, trust, and standards traceability**

PKI artifacts and standards traceability can be captured using core CycloneDX 1.7 structures. Implementers should represent certificate and key material as CycloneDX cryptographic assets (and relate them via dependencies) when detailed PKI parameters are needed. Implementers can record standards/specification traceability using CycloneDX `externalReferences` (e.g., links to 3GPP TS/TR documents) rather than encoding citations in ATIS property values.

The ATIS telecom5g taxonomy MAY be used to add concise, telecom-specific tags that improve interpretability and cross-vendor comparison, such as:


• indicating whether PKI is used for a given interface/binding (high-level usage indicator), and

• classifying trust domain/boundary context (e.g., intra-operator vs inter-PLMN/roaming).


Where possible, implementers should prefer CycloneDX-native modeling for detailed certificate attributes, validation mechanisms, and trust anchors, and use ATIS tags only where they add operational meaning without duplicating the CycloneDX model.

### **6.6. Choosing the right level of detail**

A common implementation error is over-modeling too early. A first release should capture enough structure to answer practical questions, but it does not need to record every cryptographic parameter from day one. The right level of detail is the lowest level that still supports the intended operational use cases.

## **7. Vendor and Deployed CBOM Profiles**

One of the most important decisions in a 5G CBOM is whether the BOM describes vendor capability or deployed effective posture. These are related but distinct products, and mixing them without clear labeling undermines the value of the CBOM.

### **7.1. Vendor capability CBOM**

A vendor capability CBOM describes what a network function or product supports. It is the right form when a supplier wants to declare supported protocols, algorithms, interface protections, or optional capabilities that may later be enabled by configuration.

### **7.1.a Linking a vendor CBOM to companion SBOM/HBOM (outline)**

When producing a vendor capability CBOM, implementers should link the CBOM to the companion BOM artifact(s) that describe the underlying deliverables (SBOM for software; HBOM for hardware).

• Use CycloneDX `externalReferences` with type `bom` to reference related BOM artifacts (SBOM/HBOM).

• Prefer a CycloneDX BOM-Link URN as the stable unique identifier for the referenced BOM when available.

• This linkage supports procurement traceability, ingestion workflows, and consistent cross-vendor comparison.

### **7.2. Deployed effective CBOM**

A deployed effective CBOM describes what is actually configured, negotiated, or used in a specific operator environment. It is the right form when the purpose is risk review, policy checking, PQC planning, or evidence of the current posture on the wire.

### **7.3. Why the distinction matters**

The distinction matters because a supported protocol is not the same as a deployed protocol, and an implemented algorithm is not the same as an effective negotiated algorithm. Consumers need to know whether a statement reflects product capability or deployment reality before they can assess compliance, weakness exposure, or migration readiness.

| Profile type | Best used for | Typical producer |
| --- | --- | --- |
| Vendor capability | Procurement support, product transparency, architecture planning, design review | Vendor, supplier, integrator |
| Deployed effective posture | Operational security review, compliance checking, crypto migration, operator assurance | Operator, managed service provider, deployment team |

| Recommended practice |
| --- |
| If an implementation must include both supported and effective statements in one BOM, the distinction must be explicit and consistently applied. However, separate BOMs are usually easier to interpret and govern. |



## **8. Implementation Workflow**

The implementation workflow should be simple enough for repeated use and formal enough to support quality control. A practical workflow for the ATIS 5G taxonomy contains seven stages.

1. Define the target and boundary. Decide whether the CBOM covers a product, a network function, a deployment, or a broader architecture scenario.

2. Select the scope profile. Decide whether the CBOM is vendor capability, deployed effective posture, or another clearly stated use case.

3. Identify in-scope entities. Enumerate the network functions, platform components, cryptographic libraries, protocols, and certificates that are relevant to the declared boundary.

4. Map interfaces and protections. Identify which 3GPP reference points are relevant and whether the implementation needs NF-level inventory only or interface-binding detail.

5. Author the CycloneDX BOM. Populate the base BOM fields and add the taxonomy properties required by the chosen profile and level of detail.

6. Validate. Run CycloneDX 1.7 schema validation and ATIS telecom5g taxonomy/profile conformance validation (using the published overlay schema and helper scripts) before exchange or publication.

7. Publish and maintain. Release the BOM with clear versioning and refresh it when architecture, configuration, cryptographic posture, or taxonomy release usage changes.

### **8.1. Inputs**

The source inputs for authoring will vary by organization. Common inputs include architecture diagrams, product design documentation, security specifications, configuration baselines, certificate management records, platform build data, and scanning or discovery outputs.

### **8.2. Ownership**

The most sustainable model is shared ownership. Product teams and architects supply authoritative design information; security teams define policy and validation expectations; tooling teams automate generation and checks; and governance teams manage publication and retention.

### **8.3. Iterative maturity**

Organizations should not wait for perfect data before starting. A staged maturity path is more realistic: begin with BOM-level metadata and coarse NF-level inventory, then add interface binding, effective posture, and richer dependency detail as data sources mature.

## **9. Validation and Quality Checks**

Validation should be treated as a required use step, not as an optional finishing activity. A CBOM that is syntactically valid but semantically unclear still creates risk because it can be misunderstood by consumers or rejected by ingestion pipelines.

A practical validation approach should include three layers:

Base CycloneDX validation to confirm the document is structurally valid for the declared CycloneDX version.

Taxonomy conformance checking to confirm that `atis:telecom5g` properties are used in the intended places and with coherent scope semantics. (implemented using the published overlay validation schema).

Implementation-quality review to confirm the CBOM is complete enough for its intended use case and that the scope is understandable to the consumer.



| Check category | What it confirms | Typical failure |
| --- | --- | --- |
| Syntax / schema | The BOM is valid CycloneDX and parseable by tooling | Malformed structure, invalid field types, broken dependency references |
| Taxonomy usage | Properties are attached to sensible BOM objects and scope declarations are coherent | Mixing BOM-level and component-level statements inconsistently; using unsupported patterns |
| Content quality | The CBOM is useful for the stated purpose | Missing scope declaration, unclear architecture boundary, NF inventory too shallow for claimed use case |



### **9.1. Validator artifacts (hosted on GitHub)**

Implementers should use the validation artifacts published alongside the taxonomy release (v0.6): a machine-readable taxonomy extract, a CycloneDX 1.7 overlay validation schema, and helper scripts/README for CI and local validation.

### **9.2. Validation steps (outline)**

• Obtain the current ATIS telecom5g validation package from the ATIS GitHub release used for the CBOM.

• Run CycloneDX schema validation to confirm the CBOM is structurally valid for CycloneDX 1.7.

• Run ATIS telecom5g overlay validation to confirm required BOM markers are present and any atis:telecom5g:* properties used conform to the taxonomy naming/value rules.

• For vendor CBOMs, confirm a companion SBOM/HBOM link is present using CycloneDX `externalReferences` (type `bom`).

• Review validation output and remediate: missing markers, invalid enum values, or unrecognized atis:telecom5g property names are treated as non‑conformant.

• Re-run validation after any transformation or enrichment step (merge, normalization, tool ingestion/export).

### **9.3. Recommended usage in vendor/operator pipelines (outline)**

• Vendors: validate prior to delivery (pre-submission gate) and include the profile marker and cbom.scope in every published CBOM.

• Operators/tool providers: validate on intake (ingestion gate). Only index/compare CBOMs that pass both CycloneDX schema validation and ATIS overlay validation.

• Governance: record the taxonomy/profile version used (v0.6) and revalidate when upgrading to newer releases.

Validation should happen before publication and again when a CBOM is transformed, merged, enriched, or imported into a downstream analysis system. For deployed CBOMs, validation should also be part of the refresh process when operational configuration changes.

## **10. Publication, Versioning, and Governance**

A 5G CBOM is only useful if a consumer can determine what it represents, when it was produced, and which taxonomy release it expects. Publication and governance practices therefore matter as much as authoring.

At a minimum, publication practice should address the following:

- A stable publication location or exchange mechanism for the CBOM.

- Versioning of the BOM itself so updates can be compared or superseded.

- Reference to the ATIS GitHub taxonomy release that the CBOM was authored against.

- Clear change management when scope, deployment posture, or modeling depth materially changes.

- Retention and refresh rules for vendor and deployed CBOMs.

The ATIS GitHub should be treated as the publication home for the live taxonomy and for reference examples. Local project copies should not become shadow standards. Instead, project governance should record which taxonomy release was used and should identify when a refresh is required because the implementation or the taxonomy has moved forward.

## **11. Consumption and Operational Use**

The value of a 5G CBOM does not end with document generation. The point of producing a machine-readable cryptographic inventory is to support decisions and actions. The operational uses below are the ones most strongly supported by the CycloneDX CBOM guidance and the IBM one-sheet, and they map directly to telecom needs.

| Operational use | Question answered | How the 5G CBOM helps |
| --- | --- | --- |
| Inventory and transparency | What cryptographic assets exist in the architecture? | Creates a structured inventory across NFs, interfaces, and related assets. |
| Weak-crypto discovery | Where are weak or undesired algorithms present? | Supports targeted review of algorithms, protocols, and posture statements. |
| PQC readiness | Which assets are classical-only, hybrid, or positioned for future migration? | Supports planning and prioritization for quantum-risk reduction. |
| Policy and advisory assessment | Does the environment align with policy or remediation guidance? | Enables rule-based checks using machine-readable cryptographic data. |
| Procurement and assurance | What does the supplier or operator claim, and how can it be reviewed? | Improves traceability and comparability across products and deployments. |



In practice, consumption often starts with inventory and visibility. Over time, organizations typically add higher-value uses such as risk ranking, migration planning, compliance checks, and evidence support for internal or external reviews.









## **12. Implementation Tips and Common Pitfalls**

The following practices consistently improve implementation quality:

- Start with a small number of strong modeling rules and apply them consistently.

- Declare scope explicitly at the BOM level and do not rely on readers to infer whether the CBOM is vendor or deployed.

- Use interface-binding modeling whenever the cryptographic question is interface-specific.

- Prefer structured references and machine-readable fields over narrative free text.

- Keep the CBOM aligned to current architecture reality; stale deployed posture data quickly loses value.

- Use the ATIS GitHub taxonomy as the live authority and keep examples versioned with that publication.

The following pitfalls should be avoided:

- Combining supported capability and deployed posture without clear labeling.

- Using network-function level statements where interface-level detail is required for analysis.

- Treating the presence of a library or implementation as proof of effective usage.

- Assuming that a syntactically valid BOM is automatically complete or operationally meaningful.

- Freezing a local copy of the taxonomy and then diverging from the GitHub release without governance.

## **13. Closing Guidance**

The ATIS Telecom 5G CBOM Property Taxonomy gives the telecom community a practical way to carry 3GPP 5G architecture and cryptographic inventory information in a standardized CycloneDX form. Its value is greatest when used as a living implementation profile: clear scope, clear semantics, disciplined validation, and consistent publication.

Organizations adopting the taxonomy should focus on repeatability rather than perfect completeness. A well-scoped and validated CBOM with clear vendor or deployed semantics is more useful than a larger but ambiguous document. The recommended path is to begin with a practical implementation profile, publish against the ATIS GitHub taxonomy, and expand modeling depth as data sources and operational needs mature.

| Examples policy |
| --- |
| Reference examples should be maintained on the ATIS GitHub alongside the current taxonomy release so that examples evolve with the live profile. For that reason, this guide does not include a separate appendix of worked examples. |



---
Copyright ATIS 2026 :

ATIS Telecom 5G CBOM Implementation Guide  
