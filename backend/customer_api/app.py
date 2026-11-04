from fastapi import FastAPI, HTTPException, Query

from .data import customers

app = FastAPI(
    title="Customer API",
    version="1.0.0",
    description="Local customer management API for APIM portfolio validation.",
)


@app.get("/health")
def health_check():
    return {"status": "ok", "service": "customer-api"}


@app.get("/customers")
def list_customers(
    limit: int = Query(default=10, ge=1, le=100),
    status: str | None = Query(default=None, pattern="^(active|inactive)$"),
):
    items = customers
    if status:
        items = [c for c in items if c["status"] == status]
    return {"items": items[:limit], "count": len(items[:limit])}


@app.get("/customers/{customer_id}")
def get_customer(customer_id: str):
    customer = next((c for c in customers if c["id"] == customer_id), None)
    if customer is None:
        raise HTTPException(status_code=404, detail=f"Customer '{customer_id}' not found")
    return customer
