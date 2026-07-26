> **Document type: Architecture documentation**

# CI/CD Design

## Pipeline Stages

Each of the four Mule applications builds and deploys through the same pipeline shape:

1. **Build** — `mvn clean package`, producing a deployable Mule application archive.
2. **Static checks** — dependency vulnerability scan, RAML/OAS lint against the API spec.
3. **Unit/MUnit tests** — `mvn test`, gated: pipeline fails if MUnit coverage or test results fail.
4. **Publish artifact** — versioned build artifact stored (e.g., Anypoint Exchange for the API spec, an artifact repository for the deployable package).
5. **Deploy to non-production** — automatic deploy to a Dev/QA environment on merge to the main branch.
6. **Manual approval gate** — required before promotion to a production-equivalent environment, consistent with enterprise change-control expectations.
7. **Deploy to production-equivalent environment** — CloudHub 2.0 or Runtime Fabric/Kubernetes target, using environment-specific externalized configuration (never rebuilding the artifact per environment).

## Environment Promotion Model

```
feature branch → PR → main
                        │
                        ▼
                  Dev (auto-deploy)
                        │
                        ▼
                  QA (auto-deploy, MUnit + integration smoke tests)
                        │
                 manual approval
                        ▼
                  Prod-equivalent (deploy)
```

## Reference Pipeline

A working example GitHub Actions workflow is provided at [`ci-cd/github-actions-ci.yml`](../ci-cd/github-actions-ci.yml), implementing the build/test/package stages above for a single Mule application. It uses GitHub Actions (rather than Jenkins) as a publicly reproducible equivalent to an enterprise CI system — the pipeline stages and gating logic are the transferable part of the design, not the specific tool. The deployment stage in that file targets a placeholder deployment step and is explicitly marked as **pseudocode**, since it would otherwise require real Anypoint Platform credentials to be meaningful.

## GitOps Note

Kubernetes/Runtime Fabric deployment via Argo CD GitOps is the focus of a dedicated cloud-native DevSecOps pipeline project planned as a separate repository in this portfolio, rather than duplicated here — this project's CI/CD design assumes that pipeline as the deployment mechanism when targeting Kubernetes, and CloudHub 2.0's native deployment API when targeting CloudHub.
