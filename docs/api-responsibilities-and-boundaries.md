> **Document type: Architecture documentation**

# API Responsibilities and Boundaries

| API | Layer | Owns | Does NOT own | Calls |
|---|---|---|---|---|
| **SAP System API** | System | SAP authentication, protocol translation (OData-style → REST), canonical Order data mapping, SAP-specific error translation | Business rules, aggregation with Salesforce data, channel formatting | SAP backend only |
| **Salesforce System API** | System | Salesforce authentication (OAuth2 JWT bearer), canonical Customer/Account data mapping, Salesforce-specific error translation | Business rules, order data, channel formatting | Salesforce backend only |
| **Order Process API** | Process | Orchestration of SAP + Salesforce System APIs, business rules (order status normalization, eligibility logic), order archive persistence, cross-system error aggregation | Channel-specific shaping, direct backend protocol knowledge, UI/UX concerns | SAP System API, Salesforce System API, Order Archive DB |
| **Customer Experience API** | Experience | Channel-specific response shaping, pagination/filtering exposed to consumers, request validation for consumer input | Business rules, direct backend access, data persistence | Order Process API only |

## Boundary Rules Enforced by This Design

1. **No layer skipping.** The Customer Experience API never calls a System API directly; the Order Process API never calls SAP/Salesforce credentials belonging to a System API's config — each layer only calls the layer directly beneath it.
2. **No business logic in System APIs.** System APIs perform protocol and schema translation only. If a SAP field needs business interpretation (e.g., mapping a numeric SAP status code to a human-readable order status), that mapping lives in the Order Process API, not the SAP System API, because it is a *business* interpretation, not a *protocol* translation.
3. **No backend awareness in the Experience API.** The Customer Experience API's DataWeave transformations never reference SAP or Salesforce field names — only the canonical model returned by the Order Process API. This is what allows a backend to be replaced without touching the Experience API.
4. **Single write path.** Only the Order Process API writes to the Order Archive Database. System APIs are read/write to their own backend only; the Experience API never writes directly to any datastore.
