# ADR-005: Default Deployment Target Is CloudHub 2.0, With Runtime Fabric as a Supported Alternative

**Status:** Accepted
**Date:** 2026-07-28

## Context

The four Mule applications in this project need a deployment target. MuleSoft supports fully managed CloudHub (1.0 and 2.0) and self-managed Runtime Fabric (Kubernetes-based, deployable on-prem or in a private cloud VPC). A detailed, general-purpose comparison of these two models is planned as a separate case study in this portfolio — this ADR records only the specific choice made for *this* project's fictional scenario.

## Options Considered

1. **CloudHub 2.0** — fully managed, Kubernetes-based, no infrastructure to operate, deployed in MuleSoft-managed cloud regions.
2. **Runtime Fabric** — self-managed Kubernetes-based runtime, deployable inside the organization's own network, giving direct network-level control (relevant if a backend, such as an on-prem SAP instance, cannot be reached from a public cloud without additional network bridging).

## Decision

Default to CloudHub 2.0 for this project's four APIs, since the fictional scenario's backends (SAP, Salesforce, cloud-hosted archive DB) are reachable via standard connectivity (VPN/private connectivity from CloudHub 2.0's dedicated environments) without requiring the integration runtime itself to sit inside the corporate network boundary.

## Consequences

- Lower operational ownership: no Kubernetes cluster to patch, scale, or secure — accepted as the right trade-off here because this scenario has no requirement forcing the runtime itself on-premises.
- Applications are still built to be portable to Runtime Fabric without code changes (per NFR-9 in [requirements.md](../requirements.md)), since this default is a deployment choice, not an architectural dependency — this is validated by keeping all environment-specific values externalized rather than hardcoded.
- If this fictional scenario were extended to include a backend reachable only from inside a private network with no VPN/private-link option (a realistic constraint in some real enterprise environments), this decision would be revisited in favor of Runtime Fabric — exactly the kind of condition explored in the companion case study.
