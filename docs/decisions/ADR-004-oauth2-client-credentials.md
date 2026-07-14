# ADR-004: Use OAuth 2.0 Client Credentials for System-to-System Calls

**Status:** Accepted
**Date:** 2026-07-28

## Context

Calls between the four APIs in this platform (Experience → Process → System) are system-to-system, with no end user directly present at the time of the call from one API to the next (the end user authenticated once at the Experience API's edge). We need a token strategy for these internal calls.

## Options Considered

1. **OAuth 2.0 Client Credentials grant** between each internal layer, with each API registered as its own OAuth client.
2. **Propagate the original end-user token** unchanged through every layer. Simpler (one token), but couples every internal API's authorization logic to end-user token semantics, and breaks for the dealer-portal server-to-server case where there is no end user at all.
3. **Mutual TLS (mTLS) only, no OAuth.** Strong transport-level identity, but no standard mechanism for scope-based authorization per call, and harder to manage centrally via Anypoint API Manager policies.

## Decision

Use OAuth 2.0 Client Credentials for all internal system-to-system calls (Process → System APIs, Experience → Process API), with each API's caller registered as a distinct OAuth client with its own scopes.

## Consequences

- Each internal caller can be granted the minimum scope it needs (e.g., the Experience API's client only needs read-oriented Process API scopes for lookups, plus a separate scope for order creation), enforced centrally as an Anypoint API Manager policy rather than in-flow code.
- A compromised or misbehaving client can be revoked or scope-limited independently of end-user sessions.
- This does mean end-user identity is not automatically carried through to SAP/Salesforce calls; where an end-user identity needs to reach a backend system (e.g., for audit purposes), it is passed explicitly as a payload/header field by the Process API, not implicitly via the token — a deliberate, documented trade-off rather than an oversight.
- mTLS is not excluded by this decision and could be layered on for defense-in-depth at the network level; this ADR addresses application-layer authorization only.
