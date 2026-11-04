from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI(
    title="Platform Dashboard",
    version="1.0.0",
    description="Operational dashboard for Azure API platform health and event visibility.",
)


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "dashboard"}


@app.get("/overview")
def overview() -> dict:
    return {
        "platform": "Azure API Management Platform",
        "status": "healthy",
        "services": [
            {"name": "customer-api", "status": "healthy"},
            {"name": "order-api", "status": "healthy"},
            {"name": "notification-worker", "status": "healthy"},
            {"name": "kafka-sample", "status": "healthy"},
        ],
        "environment": "dev",
        "streaming": {
            "mode": "Kafka sample",
            "topic": "orders-events",
        },
    }


@app.get("/", response_class=HTMLResponse)
def root() -> str:
    return """
    <html>
      <head>
        <title>Platform Dashboard</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; background: #f4f8fb; color: #16324f; }
          .card { background: white; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
          .pill { display: inline-block; background: #dff6dd; color: #0c5e2a; padding: 6px 12px; border-radius: 999px; }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>Azure API Platform Dashboard</h1>
          <span class="pill">Healthy</span>
        </div>
        <div class="card">
          <h2>Services</h2>
          <ul>
            <li>Customer API</li>
            <li>Order API</li>
            <li>Notification Worker</li>
            <li>Kafka Sample Producer</li>
          </ul>
        </div>
      </body>
    </html>
    """
