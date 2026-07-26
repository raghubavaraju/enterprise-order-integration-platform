> **Document type: Architecture documentation**

# Logging and Correlation-ID Strategy

## Correlation ID Propagation

Every inbound request is assigned a correlation ID, used to trace a single logical request across all four API layers and both backend systems.

1. **Origin.** If the inbound request to the Customer Experience API includes an `X-Correlation-Id` header, it is used as-is. If absent, the Experience API generates a new UUID.
2. **Propagation.** The correlation ID is attached to every outbound call the Experience API makes to the Process API (as `X-Correlation-Id`), and the Process API in turn propagates the same header to the SAP System API and Salesforce System API calls it makes. The header is also attached to the record written to the Order Archive Database.
3. **Mule's built-in correlation ID** (`message.attributes.correlationId` / event ID) is used internally within a single Mule app for intra-flow log correlation, while the `X-Correlation-Id` HTTP header is the cross-application mechanism — the two are bridged at each API's inbound endpoint so both are always available together in logs.

## Structured Logging

All four APIs emit structured (JSON) log lines rather than free-text, so logs can be filtered/aggregated by field in a log platform (e.g., Splunk, ELK) without regex parsing. A minimum log line includes:

```json
{
  "timestamp": "2026-07-28T10:15:32.401Z",
  "correlationId": "6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10",
  "application": "order-process-api",
  "flow": "order-process-main",
  "level": "INFO",
  "message": "Order lookup completed",
  "orderId": "ORD-100245",
  "durationMs": 182
}
```

## What Is Never Logged

Per NFR-7, the following are never written to logs in raw form: customer name, email address, phone number, physical address, and payment-related fields. Where a log line needs to reference a customer, it uses the internal `customerId` only. This rule is enforced by a shared logging utility/DataWeave function (documented, not fully implemented in this portfolio) that all four apps are expected to use rather than calling `logger` directly with raw payloads.

## Log Levels

| Level | Used for |
|---|---|
| `ERROR` | Unhandled exceptions, circuit breaker open events, failed retries exhausted |
| `WARN` | Retried-but-recovered calls, partial/degraded responses (e.g., Salesforce unavailable, SAP data returned) |
| `INFO` | Request received, request completed, key business decision points (e.g., "order flagged for manual review") |
| `DEBUG` | Payload-level detail, disabled in production by default |

## Reference Configuration

An example Log4j2 configuration illustrating the JSON layout described above is provided at [`mule-apps/order-process-api/src/main/resources/log4j2.xml`](../mule-apps/order-process-api/src/main/resources/log4j2.xml) — marked as a **working example** (valid Log4j2 syntax for Mule 4), applicable to all four apps with the `application` field value changed per app.
