> **Document type: Architecture documentation**

# Security Design — OAuth 2.0

## Grant Types Used

| Call path | Grant type | Why |
|---|---|---|
| Order Process API → SAP System API | Client Credentials | System-to-system call, no end-user context needed |
| Order Process API → Salesforce System API | Client Credentials | System-to-system call, no end-user context needed |
| Customer Experience API → Order Process API | Client Credentials | System-to-system call within the platform |
| Downstream consumer app → Customer Experience API | Authorization Code (web/mobile) or Client Credentials (dealer portal server-to-server) | Consumer-facing entry point; supports both end-user-authenticated channels and server-to-server partner integration |

## Token Handling

- Access tokens are requested from the platform's OAuth2 provider (modeled here as Anypoint's built-in OAuth2 provider or an external IdP such as Okta/Azure AD — either is compatible with this design) and cached until near expiry, rather than requested on every call.
- Tokens are never logged, never included in error responses, and never persisted to the Order Archive Database.
- All System APIs validate the incoming token's scope before processing a request (e.g., the SAP System API requires an `orders:read` or `orders:write` scope, enforced as an Anypoint API Manager policy rather than in-flow code, so the same enforcement applies consistently regardless of Mule application logic).

## Policy Enforcement Point

OAuth2 validation is applied as an **Anypoint API Manager policy** at the API proxy layer for every API in this project, not implemented as custom in-flow validation logic. This keeps security enforcement declarative, centrally auditable, and consistent across all four APIs regardless of which team builds a given API. The RAML specs in [`../api-specs/`](../api-specs) document the required scopes per endpoint; the actual policy binding is an Anypoint Platform configuration action and is described here rather than expressed as runnable code, since it is applied through the platform UI/API rather than in the Mule project itself.

## Configuration Placeholders

Client IDs, client secrets, and token endpoints referenced anywhere in this project (e.g., `mule-apps/*/src/main/resources/config/config-placeholder.yaml`) are **non-functional placeholders** in the form `${secure::sap.client.id}`, resolved via Mule's Secure Configuration Properties module in a real deployment. No real credential, of any kind, appears anywhere in this repository.

## Transport Security

All inter-API traffic is assumed to run over TLS 1.2+ in every environment; plaintext HTTP is a local-development-only convenience and is never a supported configuration in the deployment design.
