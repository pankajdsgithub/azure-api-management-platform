# Azure API Management Platform Architecture

## Overview
This project demonstrates API publishing, access control, rate limiting, and local testing.

## Request flow
1. API client sends a request to Azure API Management.
2. APIM applies JWT validation and rate limiting policies.
3. APIM routes requests to the Customer API or Order API.
4. Automated tests validate API behavior locally.

## Components
- Customer API: customer listing and lookup.
- Order API: order listing and lookup.
- OpenAPI JSON specifications for both APIs.
- Global rate-limiting policy.
- Microsoft Entra ID token-validation template.
- Pytest-based API tests.

## Local endpoints
- Customer API: http://127.0.0.1:8001
- Order API: http://127.0.0.1:8002
- Interactive documentation: /docs on each API.

## Security and deployment
- JWT placeholders must be configured before use.
- XML parsing alone does not prove APIM policy compatibility.
- APIM is not deployed; this diagram describes the intended architecture.
- No Azure resources are created by local validation.
