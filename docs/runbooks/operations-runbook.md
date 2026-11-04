# Platform Operations Runbook

## 1. Operating principles
This platform is designed for 24x7 operation with clear ownership, alerting, and recovery steps. Responsibilities are split across engineering, platform operations, and security teams.

## 2. Core monitoring stack
- Azure Monitor
- Log Analytics Workspace
- Application Insights
- Azure Service Bus metrics
- Container App health endpoints
- APIM gateway metrics and diagnostics

## 3. Operational alerts
- API 5xx rate above threshold
- APIM latency above baseline
- Container App unhealthy or restarted repeatedly
- Service Bus queue age and dead-letter count trending up
- Redis memory pressure or high latency
- SQL database CPU or storage saturation
- Front Door health failure across primary region

## 4. Recovery procedures
### Application outage
1. Confirm the health and readiness endpoints.
2. Inspect Azure Monitor and Application Insights traces.
3. Verify resource health and replica status.
4. Fail over to the secondary region if configured.
5. Redeploy the last known-good revision if required.

### Database issue
1. Check SQL metrics and diagnostics.
2. Verify failover group or geo-replication status.
3. Evaluate connection pool and query pressure.
4. Fail over to replica if applicable.
5. Validate application retry logic and open transactions.

### Messaging backlog
1. Review Service Bus queue depth and consumer lag.
2. Verify worker health and throughput.
3. Scale out worker pods or container app replicas.
4. Check dead-letter queues and error details.

### Security event
1. Confirm the issue in Azure Monitor and Defender for Cloud if enabled.
2. Revoke or rotate affected secrets.
3. Validate RBAC and Key Vault access.
4. Restrict the affected route or private endpoint as needed.

## 5. Change windows
Schedule infrastructure and application releases outside peak business windows whenever possible. Use environment-specific promotion gates to reduce risk.

## 6. Cost controls
- Tag every resource with environment, owner, and cost center.
- Review budgets and Advisor recommendations weekly.
- Prefer managed service autoscaling over overprovisioning.
- Keep production idle capacity planned and justified against SLOs.

## 7. Support model
- L1: monitor alerts and basic triage
- L2: application and service-level investigation
- L3: deep platform, networking, and database escalation

## 8. Runbook escalation
Use the following escalation path:
1. Platform monitoring and automated alerting
2. On-duty engineering owner
3. Database or networking specialist
4. Security and identity escalation if secret or access breach is suspected
