> **Document type: Architecture documentation**

# Scalability and Resilience Considerations

These are architectural design decisions and target behaviors for this fictional platform, not measured results from a running deployment.

## Scalability

- **Independent scaling per layer.** Each of the four APIs is packaged and deployed as its own Mule application, so the SAP System API (likely to see the highest call volume, since both the Process API and any future consumers depend on it) can be scaled independently of the Customer Experience API.
- **Stateless application design.** No API in this platform holds request-scoped state in memory beyond the lifecycle of a single request, which allows horizontal scaling (additional CloudHub 2.0 replicas / Kubernetes pods) without session affinity requirements.
- **Caching at the Experience layer.** The Customer Experience API is designed to cache Process API responses for read-heavy, low-volatility lookups (e.g., repeated order-status checks within a short window) using Mule's Cache scope backed by Object Store, reducing redundant orchestration calls for identical requests.
- **Connection pooling to backends.** SAP and Salesforce System API connectors are configured with bounded connection pools to avoid overwhelming backend systems during traffic spikes, with pool size treated as an environment-specific, externalized configuration value.

## Resilience

- **Timeouts on every outbound call.** Every HTTP request from a System API to its backend, and every call from the Process API to a System API, has an explicit timeout — no outbound call is allowed to block indefinitely.
- **Retry with backoff for transient failures.** Transient errors (timeouts, 5xx responses, connection resets) from SAP or Salesforce trigger a bounded retry with exponential backoff (implemented via Mule's `until-successful` scope), distinguishing transient failures from permanent ones (4xx responses are not retried).
- **Circuit breaker on backend calls.** System APIs implement a circuit-breaker pattern around backend calls: after a configured threshold of consecutive failures, the circuit opens and fails fast for a cool-down period, preventing a struggling backend from being hammered further and protecting the Process API from cascading timeouts.
- **Graceful degradation in the Process API.** If the Salesforce System API is unavailable but the SAP System API responds successfully, the Order Process API is designed to return a partial response (order data present, customer data marked as temporarily unavailable) rather than failing the entire request — this behavior is explicit and documented per endpoint in the RAML spec, not implicit.
- **Idempotent order creation.** Order creation requests carry a client-generated idempotency key so a retried request (e.g., after a client-side timeout) does not result in a duplicate order in SAP.

## Deployment Topology

This project's Mule applications are designed to be deployable to either **CloudHub 2.0** or a **self-managed Runtime Fabric / Kubernetes** target, using externalized environment configuration (see [ADR-005](decisions/ADR-005-cloudhub2-deployment-target.md) for the reasoning behind the default target choice). A dedicated cloud-native DevSecOps pipeline project (containerized deployment, GitOps) is planned as a separate repository in this portfolio.
