> **Document type: Architecture documentation**

# API Versioning Strategy

## Approach: URI Versioning at the Major Version Level

All APIs in this project are versioned in the URI path (e.g., `/api/v1/orders`), with the major version incremented only for **breaking changes** to the contract (removed fields, changed field types/semantics, removed endpoints).

| Change type | Example | Versioning action |
|---|---|---|
| Additive, backward-compatible | New optional response field | No version change; update RAML and changelog |
| Backward-compatible behavior change | New optional query parameter | No version change; document default behavior |
| Breaking change | Removing a field, changing a field's type, changing required/optional status | New major version (`v1` → `v2`); old version remains available during deprecation window |

## Rules

1. **RAML is the source of truth.** Every version has its own RAML file (or `version` field with a maintained changelog); a consumer can always retrieve the exact contract for the version they're bound to.
2. **Deprecation window.** A deprecated version is supported for a defined window (design target: minimum 2 release cycles) after its replacement is published, with a `Deprecation` and `Sunset` HTTP header returned on every response from the deprecated version, so this can be enforced without out-of-band communication.
3. **System APIs version independently of Process/Experience APIs.** A SAP System API version change does not force a Process API version change unless the Process API's own contract changes — this is only possible because the Process API depends on the System API's canonical model, not its version number directly.
4. **No silent breaking changes.** Any change classified as breaking must ship as a new version; it is never released in place under the existing version path.

## Applied in This Project

All four APIs in this project currently ship as `v1` (`/api/v1/...`), reflected in each RAML spec's `baseUri` and in the Mule application's base path configuration (see `mule-apps/*/src/main/resources/config/config-placeholder.yaml`).
