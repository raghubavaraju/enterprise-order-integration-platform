> **Document type: Architecture documentation**

# API-Led Architecture Overview

## Why API-Led Connectivity

Point-to-point integration between every downstream application and every backend system (SAP, Salesforce) scales poorly: the number of connections grows combinatorially, backend changes ripple across every consumer, and there is no natural place to put shared logic like error handling, security enforcement, or data transformation.

**API-led connectivity** addresses this by organizing integration into three layers, each with a distinct responsibility and rate of change:

| Layer | Purpose | Changes when... |
|---|---|---|
| **System API** | Unlocks a single backend system's data/capability behind a stable, canonical contract | The backend system's interface changes |
| **Process API** | Orchestrates one or more System APIs and applies business logic/rules | Business process logic changes |
| **Experience API** | Shapes data for a specific channel/consumer's needs | A channel's UX or data needs change |

This means a SAP interface change is absorbed entirely inside the SAP System API — the Process and Experience APIs, and every downstream consumer, are unaffected.

## Layer Design for This Project

```
Downstream Consumers (storefront, mobile app, dealer portal)
            │
            ▼
   Customer Experience API   (channel-shaped aggregate views)
            │
            ▼
      Order Process API       (orchestration, business rules, archive persistence)
        │            │
        ▼            ▼
 SAP System API   Salesforce System API
        │            │
        ▼            ▼
      SAP ERP     Salesforce CRM

 Order Process API also connects directly to the
 relational Order Archive Database (see ADR-002).
```

A full diagram is provided in [`../diagrams/architecture-overview.mmd`](../diagrams/architecture-overview.mmd) and rendered in the [project README](../README.md).

## Layer Responsibilities in Detail

### System APIs — "Unlock the system, hide its complexity"

- **SAP System API**: Wraps SAP's order-related interface (modeled here as an OData-style service) behind a clean REST contract. Owns SAP-specific authentication, protocol translation, and canonical data mapping for order data. Consumers never talk to SAP directly.
- **Salesforce System API**: Wraps Salesforce customer/account objects behind a clean REST contract. Owns Salesforce-specific authentication (OAuth2 JWT bearer, in the fictional design) and canonical data mapping for customer data.

### Process API — "Own the business process"

- **Order Process API**: Orchestrates calls to the SAP and Salesforce System APIs, combines their responses into a canonical Order+Customer domain model, applies business rules (e.g., order status normalization, eligibility checks), and persists an order summary to the relational Order Archive Database. This is where cross-system business logic lives — not in the System APIs, and not in the Experience API.

### Experience API — "Shape data for the channel"

- **Customer Experience API**: Consumed by the storefront, mobile app, and dealer portal. Calls the Order Process API and reshapes/filters the response for the specific channel (e.g., the mobile app gets a lightweight summary; the dealer portal gets additional account and pricing-tier fields). No business logic lives here — only presentation shaping, pagination, and channel-specific field selection.

## Why Not Fewer Layers

A common question in architecture interviews: *why not let the Experience API call SAP and Salesforce directly, skipping the Process API?* This project's answer, recorded formally in [ADR-001](decisions/ADR-001-api-led-layering.md), is that doing so would push business orchestration logic into every channel-specific API, duplicating it across the storefront, mobile, and dealer-portal experience layers as they're added over time — reintroducing the exact coupling problem this architecture exists to remove.
