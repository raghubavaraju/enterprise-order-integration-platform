> **Document type: Architecture documentation**

# MUnit Testing Strategy

## Principles

1. **Every flow that touches an external system is tested with the external call mocked.** MUnit's `mock-when`/`then-return` is used to stub SAP, Salesforce, and database connector calls so tests are deterministic and runnable without live backends or credentials.
2. **Test both the success path and the documented failure paths.** For each flow, MUnit suites cover: happy path, backend timeout, backend 4xx/5xx response, and (for the Process API) partial-failure/graceful-degradation behavior.
3. **Assert on the contract, not the implementation.** Tests assert against the response structure defined in the RAML spec (status code, required fields, error shape), so tests remain valid if internal flow implementation is refactored.
4. **Error-handling flows are tested directly**, not only indirectly through a failing happy-path test — the global error handler has its own MUnit suite validating that each error type maps to the correct standardized error response.

## Coverage Plan by API

| API | Key test scenarios |
|---|---|
| SAP System API | Successful order lookup; SAP backend timeout → circuit breaker/error mapping; SAP returns "order not found" → 404 mapping; malformed SAP response → 502 mapping |
| Salesforce System API | Successful customer lookup; Salesforce auth failure → 401/502 mapping; Salesforce rate-limit response → retry then error mapping |
| Order Process API | Successful orchestration (both System APIs succeed); Salesforce unavailable → partial/degraded response; SAP unavailable → full failure with standardized error; idempotency key reused → duplicate-safe response; archive DB write failure → response still returned with a logged/flagged archive failure |
| Customer Experience API | Successful aggregate response shaped per channel header; Process API failure propagated as standardized error; pagination parameters applied correctly |

## Working Example

A representative, runnable MUnit test suite is provided for the **Order Process API**'s main orchestration flow at [`mule-apps/order-process-api/src/test/munit/order-process-api-test.xml`](../mule-apps/order-process-api/src/test/munit/order-process-api-test.xml), covering the happy path and the Salesforce-unavailable degraded-response scenario. It is marked as a **working example** — valid MUnit 2.x syntax intended to run via `mvn test` inside a real Mule project — and is intended as the pattern to replicate across the other three APIs, not as full coverage of every scenario in the table above.
