from fastapi import FastAPI, HTTPException

app = FastAPI(title="Order API", version="1.0.0")

ORDERS = {
    1001: {"id": 1001, "customer_id": 1, "status": "processing"},
    1002: {"id": 1002, "customer_id": 2, "status": "shipped"},
}

@app.get("/healthz")
def health():
    return {"status": "healthy", "service": "order-api"}

@app.get("/orders")
def list_orders():
    return list(ORDERS.values())

@app.get("/orders/{order_id}")
def get_order(order_id: int):
    order = ORDERS.get(order_id)
    if order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return order
