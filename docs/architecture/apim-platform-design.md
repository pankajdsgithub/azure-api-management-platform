# APIM Platform Design

## 1. Objective
Define the target design for publishing Customer API and Order API through Azure API Management (APIM).
This document describes the intended architecture; no Azure resources are deployed.

## 2. Logical request flow
API Consumer -> APIM Gateway -> Authentication -> Rate Limiting -> Backend API

## 3. API catalogue
| API | Initial version | Operations |
|---|---|---|
| Customer API | v1 | GET /customers, GET /customers/{customer_id} |
| Order API | v1 | GET /orders, GET /orders/{order_id} |

Use versioned API contracts. Confirm the final URL versioning convention before implementation.

## 4. Consumer products
| Product | Intended consumer | Initial access model |
|---|---|---|
| Internal Standard | Internal applications | Entra ID token plus APIM subscription where required |
| Partner Standard | Approved partners | Entra ID token plus product subscription |
| Read Only | Approved read-only clients | GET operations only, subject to authorization |

These products are proposed design choices, not deployed resources. Confirm whether every product requires a subscription.

## 5. Identity and access
- Use Microsoft Entra ID access tokens for authenticated APIs.
- Validate token issuer, audience, lifetime and permitted client application as appropriate.
- Define required scopes or app roles for each API operation.
- Treat APIM subscription keys as product access and usage identifiers, not as user authentication.
- Never commit client secrets, access tokens or credentials.

## 6. Policy strategy
- Global scope: common baseline and shared protections.
- Product scope: product-specific quotas and access rules where appropriate.
- API or operation scope: token authorization and operation-specific restrictions.
- Preserve intended inherited policies with the base element.
- Confirm policy inheritance and rate-limit behavior before deployment.
- Do not treat XML parsing as proof of APIM policy compatibility.

## 7. Initial traffic policy proposals
- Internal Standard: 100 calls per 60 seconds per intended counter key.
- Partner Standard: quota to be agreed with each integration owner.
- Read Only: quota to be agreed after expected traffic is known.
- Return HTTP 429 when the configured rate limit is exceeded.
- Validate whether the selected APIM tier supports the intended policies.

## 8. Error handling
- 400: invalid request.
- 401: missing or invalid authentication.
- 403: authenticated caller lacks permission.
- 404: requested resource not found.
- 429: rate limit exceeded.
- 500: unexpected backend or gateway failure.
- Use a consistent JSON error structure and avoid exposing secrets or stack traces.

## 9. Observability
- Capture request volume, latency, status codes and backend failures.
- Define alerts for sustained 5xx errors, latency increases and rate-limit spikes.
- Do not log bearer tokens, subscription keys or sensitive personal data.

## 10. Implementation sequence
1. Confirm identity, consumer and product decisions.
2. Review API contracts and policy compatibility.
3. Design Terraform modules and environment inputs.
4. Add CI validation and security checks.
5. Deploy only after explicit approval.

## 11. Enterprise security and governance baseline

- Require Microsoft Entra ID access-token validation for protected APIs.
- Validate the configured tenant, audience, permitted client applications and
  required authorization claims as applicable to the API registration model.
- Enforce least-privilege scopes or app roles at the relevant API operations.
- Do not treat APIM subscription keys as authentication.
- Keep secrets, tokens, credentials and production configuration out of Git.
- Prefer managed identities and Azure Key Vault integration where supported.
- Restrict backend network access to approved callers and APIM connectivity.
- Decide gateway public/private exposure only after consumer and network
  requirements and the selected APIM tier are confirmed.
- Apply request validation, safe error responses and API threat protections
  appropriate to each API contract.
- Define product-specific throttling and quotas from approved traffic needs.
- Monitor latency, availability, 4xx/5xx responses, throttling and backend
  failures; avoid logging tokens, keys or sensitive personal data.
- Require CI checks for OpenAPI, policy compatibility, Terraform formatting
  and validation, and infrastructure security scanning.
- Use least-privilege RBAC, environment separation, approved changes and
  documented ownership.
- Define recovery, capacity and regional availability requirements before
  selecting the production APIM tier and topology.

## 12. Decisions required before Terraform

1. Confirm Entra tenant, API audience, client applications and scopes/app roles.
2. Confirm internal and partner subscription requirements.
3. Confirm backend hosting and private connectivity requirements.
4. Select APIM tier and gateway exposure based on required features, availability,
   networking, capacity and budget.
5. Agree partner quotas, read-only quotas, service objectives and alert thresholds.
6. Validate policies against the selected APIM tier before deployment.
7. Approve the design before Terraform implementation or Azure deployment.


<!-- HYBRID-APIM-ARCHITECTURE-2026-10 -->

## Architecture Decision: Hybrid Access with Standard v2

### Decision status
- Consumer model: Hybrid — internal private consumers and external partners.
- Initial APIM tier: Standard v2.
- Deployment status: Documentation and local validation only. No Azure resources
  are authorized for deployment by this decision.
- Network exposure and isolation controls remain subject to design review.

### Request paths

1. Internal consumers connect through an approved corporate network, VPN,
   ExpressRoute, or peered VNet to an APIM inbound Private Endpoint.
2. External partners use HTTPS through the approved public ingress path.
   Entra ID token validation and partner-specific authorization are mandatory.
3. APIM reaches private backends through outbound VNet integration, subject
   to routing, DNS, NSG, and backend firewall rules.
4. Both request paths use the same approved API contracts, monitoring standards,
   error handling, and policy governance.

### Important Standard v2 networking constraints

- Standard v2 supports outbound VNet integration for private backend connectivity.
- An inbound Private Endpoint provides private access to the APIM gateway.
- The public gateway remains accessible while public network access is enabled.
- Disabling public network access requires a configured Private Endpoint.
- A Private Endpoint does not by itself make selected APIs private when the
  same APIM instance also has public access.
- API-level source restrictions must be explicitly implemented and tested.
- If strict network separation between internal and partner APIs is required,
  evaluate separate APIM instances or a reviewed WAF/edge architecture that
  supports private connectivity to APIM.
- Confirm region, subscription, tier, provider and feature availability before
  finalizing Terraform resources.

### API exposure and authorization

- Internal APIs: accept requests only from approved private ingress paths;
  deny requests arriving through unapproved public ingress.
- Partner APIs: use HTTPS and validate Entra ID JWT issuer, audience,
  lifetime, signature, and required scopes or app roles.
- Apply least-privilege authorization at API and operation level.
- Subscription keys may support product subscription and usage tracking;
  they are not a replacement for authentication or authorization.
- Use separate products, subscriptions, scopes/roles, and quotas where needed
  to distinguish internal and partner consumers.
- Do not rely on a product name or subscription key alone to create a
  network-isolation boundary.
- Keep API versions explicit, for example `/v1/customers` and `/v1/orders`.

### Networking prerequisites

- Approved VNet and subnet plan, address ranges, and non-overlapping CIDRs.
- Dedicated subnet for Standard v2 outbound VNet integration, delegated as
  required by the current Microsoft guidance.
- Private Endpoint subnet and private endpoint connection approval.
- NSG, route table, firewall, peering, VPN/ExpressRoute and egress requirements.
- Explicit ingress design for partner traffic: direct public gateway with
  appropriate protections, or an approved WAF/edge design.
- A tested policy strategy that distinguishes approved private traffic from
  public partner traffic when sharing an APIM instance.
- No broad backend ingress from the internet; allow only required APIM/network
  paths where the backend technology supports those controls.

### Identity and secrets prerequisites

- Entra ID tenant ID, API audience/application ID, client application IDs,
  delegated scopes and/or application roles.
- Token issuer, accepted claims, allowed callers and authorization matrix.
- Separate identities and least-privilege RBAC for deployment and runtime.
- Prefer managed identity for supported Azure-to-Azure authentication.
- Store secrets and certificates in Key Vault or an approved secret store;
  never commit credentials, tokens, certificates, or real tfvars to Git.
- Define key rotation, certificate renewal, and emergency credential revocation.

### Backend prerequisites

- Decide where Customer API and Order API will run and how they are reached.
- Confirm backend FQDNs, ports, TLS certificates, health checks and timeouts.
- Determine private DNS zones, private endpoint needs, peering and routing.
- Decide backend authentication: managed identity, OAuth, mTLS, or another
  approved mechanism supported by the target backend.
- Restrict direct backend access where feasible so callers cannot bypass APIM.
- Keep local FastAPI test backends separate from any future Azure backend.

### DNS and TLS prerequisites

- Private DNS resolution for APIM's inbound Private Endpoint, using the
  Microsoft-documented Private Link DNS configuration.
- DNS resolution from APIM's VNet-integrated path to private backend FQDNs.
- Decide whether internal and partner consumers use different hostnames.
- For Standard v2 custom gateway domains, verify the current requirement for
  publicly resolvable DNS names and any approved edge workaround.
- Use valid certificates, controlled renewal, TLS validation and documented
  ownership of public and private DNS zones.

### Diagnostics and operations prerequisites

- Send APIM gateway/resource logs and metrics to the approved monitoring target.
- Decide Log Analytics workspace, diagnostic categories, retention and access.
- Define alerts for gateway failures, backend failures, latency, capacity,
  throttling, authentication failures and unusual traffic.
- Define availability targets, operational ownership, incident runbooks and
  escalation paths.
- Avoid logging bearer tokens, subscription keys, secrets or sensitive payloads.
- Establish baseline dashboards, SLOs, alert thresholds and test procedures
  before production rollout.

### Terraform implementation prerequisites

- Pin and validate Terraform and AzureRM provider versions.
- Define reusable modules for APIM service, APIs, products, policies and monitoring.
- Decide remote state storage, locking, encryption, access controls and recovery.
- Use separate dev, test and prod state/configuration and separate environment
  approval gates.
- Define resource naming, region, tags, diagnostics, RBAC and policy standards.
- Keep real environment tfvars, credentials and generated plan files out of Git.
- Add CI checks for fmt, init/validate, OpenAPI JSON, XML policy syntax,
  security scanning and plan review.
- Require explicit human approval before any apply, especially in production.
- Do not run plan/apply or create Azure resources as part of this documentation step.

### Open decisions before deployable Terraform

1. One APIM instance with carefully enforced API ingress restrictions, or
   separate instances for stronger isolation?
2. Direct public partner ingress, or WAF/edge ingress with private connectivity?
3. Azure region, VNet CIDRs, subnet sizing, DNS ownership and backend hosting.
4. Entra ID tenant, audiences, scopes/roles, approved partner applications.
5. Monitoring destination, retention, SLOs, alerts and operational owners.
6. Remote state design, provider versions, RBAC and CI approval model.
7. Cost estimate, tier availability, quotas, capacity and recovery requirements.

### Official design references

- Networking options:
  https://learn.microsoft.com/en-us/azure/api-management/virtual-network-concepts
- Standard v2 outbound VNet integration:
  https://learn.microsoft.com/en-us/azure/api-management/integrate-vnet-outbound
- Inbound Private Endpoint:
  https://learn.microsoft.com/en-us/azure/api-management/private-endpoint
