# Reference Azure Platform

This directory contains a Terraform reference implementation for the architecture described in the project documentation. It provisions the core Azure platform resources required for a secure, resilient, multi-service application stack.

## Included services
- Resource group
- Log Analytics and Application Insights
- Key Vault
- Azure SQL Database
- Azure Cache for Redis
- Azure Storage Account with GRS replication
- Azure Service Bus namespace and queue
- Azure Container Apps environment and app services
- Azure API Management

## Important notes
- This configuration is designed as a reference example, not a production deployment manifest.
- Replace placeholder values or environment variables before applying in Azure.
- Do not commit secrets or production credentials to Git.
- Use separate environments for dev, test, and prod with locked state.
