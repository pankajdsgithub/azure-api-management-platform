import importlib.util
from pathlib import Path

from fastapi.testclient import TestClient

ROOT = Path(__file__).resolve().parents[1]

def load_app(relative_path, module_name):
    path = ROOT / relative_path
    spec = importlib.util.spec_from_file_location(module_name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.app

customer_app = load_app("backend/customer-api/main.py", "customer_api")
order_app = load_app("backend/order-api/main.py", "order_api")

def test_customer_health():
    response = TestClient(customer_app).get("/healthz")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_customer_found():
    response = TestClient(customer_app).get("/customers/1")
    assert response.status_code == 200
    assert response.json()["id"] == 1

def test_customer_not_found():
    assert TestClient(customer_app).get("/customers/999").status_code == 404

def test_order_health():
    response = TestClient(order_app).get("/healthz")
    assert response.status_code == 200
    assert response.json()["service"] == "order-api"

def test_order_found():
    response = TestClient(order_app).get("/orders/1001")
    assert response.status_code == 200
    assert response.json()["customer_id"] == 1

def test_order_not_found():
    assert TestClient(order_app).get("/orders/9999").status_code == 404
