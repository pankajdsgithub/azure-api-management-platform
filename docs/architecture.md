# Enterprise APIM architecture

## High-level flow

```mermaid
flowchart LR
    A[API Consumer\nPartner / Mobile / Web App] --> B[Azure API Management\nGateway]
    B --> C[Customer API\nFastAPI Backend]
    B --> D[Order API\nFastAPI Backend]
    B --> E[Identity Boundary\nMicrosoft Entra ID\nOAuth2 / OIDC]
    B --> F[Azure Key Vault\nCertificates and Secrets]
    B --> G[Azure Monitor\nApplication Insights]
    C --> H[Local Demo Runtime]
    D --> H
    E --> I[JWT Validation\nIssuer / Audience / Expiry]
    F --> B
    G --> J[Operations / Dashboards / Alerts]

    classDef azure fill:#dbeafe,stroke:#1d4ed8,color:#0f172a;
    classDef app fill:#dcfce7,stroke:#15803d,color:#0f172a;
    classDef identity fill:#fef3c7,stroke:#b45309,color:#0f172a;

    class A,B,C,D,E,F,G,H,I,J azure;
    class H app;
    class E,I identity;
```

## Local demo intent

This repository intentionally separates the local runnable demonstration from Azure-specific production architecture. The local services are designed to run without Azure credentials and are used to validate API contract and behavior.

## Production architecture intent

In a real enterprise Azure environment, the architecture would include:

- API consumers and internal or partner applications
- Azure API Management gateway for routing, throttling, policies, and product isolation
- Customer and Order APIs as backend services behind the gateway
- Microsoft Entra ID for OAuth 2.0 and OIDC validation
- Azure Key Vault for certificates and secret references
- Managed identity for secure downstream authentication
- Azure Monitor and Application Insights for telemetry and diagnostics
- GitHub Actions for validation-only CI and controlled release workflows
- Optional private networking for backend communication and private endpoints

## Distinction between local and Azure

The local code in this repository is not a deployed APIM environment. It is intended to validate:

- contract stability
- backend behavior
- testability
- policy design patterns
- engineering documentation quality

The Azure deployment model and APIM operational configuration are intentionally deferred to a future approved deployment phase.
