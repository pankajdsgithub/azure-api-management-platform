from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Notification Worker", version="1.0.0")


class OrderEvent(BaseModel):
    order_id: str
    customer_id: str
    status: str
    total: float
    currency: str = "USD"


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "notification-worker"}


@app.post("/events/order-created")
def process_order_created(event: OrderEvent) -> dict:
    return {
        "accepted": True,
        "message": "Order event accepted for downstream processing",
        "order_id": event.order_id,
        "customer_id": event.customer_id,
        "status": event.status,
    }


@app.post("/events/order-approved")
def process_order_approved(event: OrderEvent) -> dict:
    return {
        "accepted": True,
        "message": "Approval notification triggered",
        "order_id": event.order_id,
        "customer_id": event.customer_id,
        "status": event.status,
    }
