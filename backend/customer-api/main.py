from fastapi import FastAPI, HTTPException

app = FastAPI(title="Customer API", version="1.0.0")

CUSTOMERS = {
    1: {"id": 1, "name": "Asha Sharma", "email": "asha@example.test"},
    2: {"id": 2, "name": "Rahul Verma", "email": "rahul@example.test"},
}

@app.get("/healthz")
def health():
    return {"status": "healthy", "service": "customer-api"}

@app.get("/customers")
def list_customers():
    return list(CUSTOMERS.values())

@app.get("/customers/{customer_id}")
def get_customer(customer_id: int):
    customer = CUSTOMERS.get(customer_id)
    if customer is None:
        raise HTTPException(status_code=404, detail="Customer not found")
    return customer
