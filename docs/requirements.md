> **Document type: Architecture documentation**

# Requirements

## Functional Requirements

| ID | Requirement |
|---|---|
| FR-1 | The platform shall expose a unified capability to retrieve order details by order ID, abstracting SAP as the system of record. |
| FR-2 | The platform shall expose a unified capability to retrieve customer/account details by customer ID, abstracting Salesforce as the system of record. |
| FR-3 | The platform shall support creation of a new order, validating request data and submitting it to SAP. |
| FR-4 | The platform shall combine order data (SAP) and customer data (Salesforce) into a single aggregate view for consumer-facing channels. |
| FR-5 | The platform shall persist a copy of processed order summaries to the relational order archive database for historical/reporting access. |
| FR-6 | The platform shall support retrieval of historical orders from the relational archive when a request falls outside SAP's active order retention window. |
| FR-7 | The Customer Experience API shall support channel-appropriate response shaping (e.g., a lightweight summary for mobile vs. a fuller record for the dealer portal), driven by query parameters or headers rather than separate APIs per channel. |
| FR-8 | All list-returning endpoints shall support pagination (`offset`, `limit`) and basic filtering (e.g., by status, date range). |
| FR-9 | All APIs shall return a consistent, documented error response structure regardless of which layer or backend system produced the error. |
| FR-10 | All APIs shall require authentication via OAuth 2.0 and shall reject unauthenticated requests. |

## Nonfunctional Requirements

Nonfunctional requirements below are stated as **architectural design targets** for this fictional scenario — they are design goals the architecture is built to satisfy, not measured production results from any real deployment.

| ID | Category | Requirement |
|---|---|---|
| NFR-1 | Security | All inter-API and external-facing calls must be secured with OAuth 2.0. System-to-system calls (Process API → System APIs) use the client credentials grant; the Experience API is designed to support the authorization code grant for eventual end-user-context calls. |
| NFR-2 | Performance | Experience API aggregate reads are designed to target sub-500ms P95 latency for cached responses and sub-1.5s P95 for full backend orchestration, under expected channel traffic. These are design targets used to drive caching and timeout decisions, not measured results. |
| NFR-3 | Availability | The Process and Experience API tier is designed for horizontal scaling and zero-downtime redeployment (CloudHub 2.0 replica model), targeting no single point of failure within the integration tier itself. |
| NFR-4 | Scalability | Each API is independently deployable and horizontally scalable; System APIs can scale independently of Process/Experience APIs based on backend call volume. |
| NFR-5 | Resilience | Calls to SAP and Salesforce must implement timeout, retry-with-backoff, and circuit-breaker behavior so a slow or unavailable backend degrades gracefully rather than cascading failure upstream. |
| NFR-6 | Observability | Every request must carry and propagate a correlation ID across all API layers, and structured logs must be emitted at each layer to support end-to-end request tracing. |
| NFR-7 | Data Privacy | Logs must not contain raw PII (customer name, email, phone, address); PII fields must be masked or omitted from log output. |
| NFR-8 | Maintainability | All APIs must be spec-first (RAML), versioned, and governed by the shared naming, error-handling, and security conventions documented in this repository. |
| NFR-9 | Portability | Mule applications must be deployable to both CloudHub 2.0 and a self-managed Runtime Fabric/Kubernetes target without code changes, using externalized environment configuration. |
