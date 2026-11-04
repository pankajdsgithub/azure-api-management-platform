# Application CI/CD and Azure Deployment Strategy

## 1. Purpose
This deployment model provides a repeatable release path for the customer and order APIs, worker service, and shared Azure infrastructure. It supports automated quality gates, role-based approvals, and staged promotion from development to production.

## 2. Release stages

```mermaid
flowchart LR
    A[Developer push] --> B[PR validation]
    B --> C[Build artifacts]
    C --> D[Security scanning]
    D --> E[Deploy dev]
    E --> F[Smoke tests]
    F --> G[Approval gate]
    G --> H[Deploy test]
    H --> I[Production rollout]
    I --> J[Post-deploy verification]
```

## 3. Pipeline design
### Stage 1: validation
- Run Python tests: `pytest -q`
- Validate OpenAPI contracts and schemas
- Run Terraform formatting and validation
- Run linting and secret scanning

### Stage 2: build
- Build container images for customer API, order API, and worker service
- Push images to Azure Container Registry
- Publish deployable infrastructure artifacts

### Stage 3: security and governance
- Enforce dependency scanning and vulnerability review
- Confirm Azure Policy, RBAC, and tag compliance
- Validate environment-specific secrets and configuration requirements

### Stage 4: deployment
- Deploy infrastructure with Terraform to dev and test
- Deploy app revisions to Azure Container Apps
- Validate health endpoints and API smoke tests

### Stage 5: production promotion
- Require manual approval
- Use a canary or blue-green rollout strategy
- Shift traffic gradually through APIM or Front Door
- Roll back quickly if health checks or synthetic tests fail

## 4. Recommended pipeline identity
Use a dedicated Azure deployment principal or GitHub OIDC federated identity with narrow scope. The identity should have permission only for the target environment and only for the required resource group or subscription scope.

## 5. Example GitHub Actions workflow
The repository contains a production-ready pipeline definition at [.github/workflows/azure-platform-cicd.yml](.github/workflows/azure-platform-cicd.yml). It includes:
- validation jobs for Python and Terraform
- image build and ACR publish steps
- dev and production deployment steps
- environment approvals

## 6. Zero-downtime release strategy
- Deploy a new revision without removing the active version.
- Use container revisioned deployments and traffic-weight updates.
- Use APIM revisioning or versioned backend routes for API updates.
- Validate health before traffic shift.
- Keep database schema changes backward compatible during rollout.

## 7. Rollback approach
- Retain prior image tags in ACR.
- Restore the previous Container App revision with one command.
- Revert APIM backend routes if needed.
- Re-run synthetic tests after rollback to confirm recovery.

## 8. Operational checklist
- Confirm the app is healthy after deployment.
- Check key metrics in Azure Monitor and Application Insights.
- Verify Service Bus queue health and dead-letter counts.
- Review Key Vault access and RBAC drift.
- Confirm all tagging, logging, and diagnostic settings are present.

## 9. Security guardrails
- Never commit secrets to the repository.
- Use environment-protected variables and managed identity.
- Limit deployment permissions to the specific environment.
- Require approval before production changes.
