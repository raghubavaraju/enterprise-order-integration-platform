# ADR-002: Order Process API Owns the Relational Archive Database Connection Directly

**Status:** Accepted
**Date:** 2026-07-28

## Context

The platform needs to write processed order summaries to a relational Order Archive Database and read historical orders that fall outside SAP's active retention window. The four named APIs in this project's scope are SAP System API, Salesforce System API, Order Process API, and Customer Experience API — there is no separate "Order Archive System API" in scope. We need to decide where the database connection lives.

## Options Considered

1. **Introduce a fifth API: Order Archive System API.** Most consistent with a strict reading of "one System API per backend system," but adds a fifth deployable unit and an extra network hop for a relatively simple CRUD dataset, for a capability only the Process API consumes today.
2. **Order Process API connects to the database directly**, treating the archive DB as an owned datastore of the process layer rather than a "system to unlock" for multiple consumers.
3. **Customer Experience API connects to the database directly** for historical reads, bypassing the Process API for that one capability. Rejected outright — it would violate the boundary rule that only the Process API performs writes/owns persistence (see [API responsibilities and boundaries](../api-responsibilities-and-boundaries.md)).

## Decision

The Order Process API owns the relational Order Archive Database connection directly, for both writes (archiving processed orders) and reads (historical order lookups outside SAP's retention window).

## Consequences

- One fewer deployable unit and network hop than Option 1, at the cost of the Process API having two responsibilities (orchestration and persistence) instead of one.
- If a second consumer of the archive database emerges in the future (e.g., a reporting system needing direct query access), this decision should be revisited — at that point, promoting the archive to its own System API (Option 1) becomes the right call, and this ADR should be superseded.
- This decision is scenario-specific, not a general rule: it reflects that the archive DB in this fictional scenario is a simple, low-complexity datastore with a single consumer today, not a broadly shared system of record like SAP or Salesforce.
