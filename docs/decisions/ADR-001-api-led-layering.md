# ADR-001: Use Three-Layer API-Led Connectivity Instead of Direct Channel-to-Backend Calls

**Status:** Accepted
**Date:** 2026-07-28

## Context

Downstream consumer applications (storefront, mobile app, dealer portal) each need order and customer data. The data lives in two systems (SAP, Salesforce) plus a relational archive. We need to decide whether channels should call backend-specific APIs directly (fewer layers, less latency) or go through an orchestration/experience layering model (more layers, more indirection).

## Options Considered

1. **Direct point-to-point.** Each channel calls SAP and Salesforce directly. Lowest latency, no extra hops, but reintroduces the exact coupling and duplicated-logic problem this platform exists to solve (see [business problem statement](../business-problem-statement.md)).
2. **Two-layer (System + Experience, no Process layer).** Channels call a single Experience API per channel, which calls System APIs directly. Removes one hop, but forces orchestration/business-rule logic to live in the Experience API — and if a second channel is added later, that logic must be duplicated or extracted anyway.
3. **Three-layer API-led connectivity (System / Process / Experience).** Adds one internal hop but cleanly separates backend unlocking, business orchestration, and channel shaping into independently owned, independently versioned layers.

## Decision

Adopt the three-layer API-led connectivity model: SAP System API, Salesforce System API, Order Process API, Customer Experience API.

## Consequences

- Business orchestration logic (combining SAP + Salesforce data, applying business rules) is written once, in the Order Process API, and reused by every current and future channel.
- Adding a new channel (e.g., a future partner integration) requires only a new Experience API (or a new mode within the existing one) — no changes to the Process or System APIs.
- A SAP or Salesforce interface change is absorbed entirely within its System API.
- Trade-off accepted: an additional network hop (Experience → Process → System) versus the two-layer alternative, which is judged acceptable given the NFR-2 latency targets and the caching strategy described in [scalability-and-resilience.md](../scalability-and-resilience.md).
- This decision assumes the organization is willing to operate and govern four independently deployable Mule applications rather than one — a real organizational cost that is worth it only when multiple channels or long-lived platform investment justify it, which is assumed true for this scenario.
