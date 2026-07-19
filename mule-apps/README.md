# mule-apps/

Standard Mule 4 / Maven application folder structures for the four APIs in this project. Each subfolder is laid out the way a real Anypoint Studio / Mule Maven project is structured, so the layout itself — not just the code inside it — is part of what's being demonstrated.

```
mule-apps/
├── common/
│   └── global-error-handler.xml        (shared reusable error handler, see docs/... error design)
├── sap-system-api/
│   ├── pom.xml
│   ├── mule-artifact.json
│   └── src/
│       ├── main/
│       │   ├── mule/
│       │   │   └── sap-system-api.xml       ← STATUS: working example flow
│       │   └── resources/
│       │       ├── config/config-placeholder.yaml   ← STATUS: configuration placeholder
│       │       ├── dwl/sap-order-to-canonical.dwl    ← STATUS: working example
│       │       └── log4j2.xml
│       └── test/
│           └── munit/sap-system-api-test.xml   ← STATUS: pseudocode (pattern only; see order-process-api for a fully worked MUnit example)
├── salesforce-system-api/   (same shape as sap-system-api)
├── order-process-api/       (same shape; includes the fully-worked MUnit example)
└── customer-experience-api/ (same shape)
```

**Status legend**, applied per file below and repeated in the [project README](../README.md):
- **Working example** — syntactically valid, runnable in a real Mule/Maven environment with the fictional backends mocked or stubbed; not deployed anywhere.
- **Pseudocode** — illustrates the intended logic/structure but is not guaranteed to compile/run as-is (used where full implementation would add length without adding architectural value).
- **Configuration placeholder** — non-functional example values only; never a real credential.
