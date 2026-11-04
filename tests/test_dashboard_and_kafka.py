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


dashboard_app = load_app("backend/dashboard/main.py", "dashboard_app")
kafka_app = load_app("backend/kafka-sample/main.py", "kafka_sample_app")


def test_dashboard_health():
    response = TestClient(dashboard_app).get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_dashboard_overview():
    response = TestClient(dashboard_app).get("/overview")
    assert response.status_code == 200
    assert "services" in response.json()


def test_kafka_health():
    response = TestClient(kafka_app).get("/health")
    assert response.status_code == 200
    assert response.json()["service"] == "kafka-sample"


def test_kafka_publish_event():
    response = TestClient(kafka_app).post(
        "/events/order",
        json={
            "order_id": "ORD-1001",
            "customer_id": "CUST-01",
            "status": "created",
            "total": 99.99,
        },
    )
    assert response.status_code == 200
    payload = response.json()
    assert payload["topic"] == "orders-events"
