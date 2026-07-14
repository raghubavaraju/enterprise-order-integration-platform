# ADR-003: Order Creation Is Synchronous Request-Reply, Not Event-Driven

**Status:** Accepted
**Date:** 2026-07-28

## Context

Order creation could be implemented as a synchronous REST call (client waits for SAP order creation to complete) or as an asynchronous, event-driven flow (client submits an order request, receives an acknowledgment, and is notified later of completion). This project's companion project, [`event-driven-supply-chain-integration`](https://github.com/raghubavaraju/event-driven-supply-chain-integration), uses an event-driven model for inventory/shipment/fulfillment events — this ADR explains why order creation in *this* project intentionally does not.

## Options Considered

1. **Synchronous request-reply.** The Customer Experience API call blocks through the Process API and SAP System API until SAP confirms order creation, then returns a result to the caller in the same HTTP response.
2. **Asynchronous, event-driven.** The Experience API accepts the order request, publishes an event, returns an immediate "accepted" response, and the caller polls or receives a callback/webhook when SAP processing completes.

## Decision

Order creation in this project uses synchronous request-reply.

## Consequences

- Simpler client integration: the storefront, mobile app, and dealer portal all need immediate order confirmation (including a real order number) to complete their own user-facing flow (e.g., an order confirmation page) — an asynchronous model would require every channel to build polling or webhook-handling logic for a single, relatively fast backend call.
- SAP order creation, in this scenario, is a request that completes within a bounded time suitable for a synchronous HTTP call (seconds, not minutes), governed by the timeout and retry design in [scalability-and-resilience.md](../scalability-and-resilience.md) — this assumption is what makes the synchronous choice viable, and it is the same assumption that would justify revisiting this decision if order creation ever became a longer-running, multi-step process.
- Trade-off accepted: the caller's HTTP connection is held open for the duration of SAP processing, bounded by the configured timeout, and a client-generated idempotency key (see [requirements.md](../requirements.md), FR-3) is required to make retries after a client-side timeout safe.
- This is a deliberately different choice from the event-driven approach used for inventory/shipment/fulfillment events, where multiple independent consumers and unbounded processing time make request-reply the wrong fit — the two projects together are meant to demonstrate that the choice between synchronous and event-driven integration is a per-use-case architectural decision, not a platform-wide default.
