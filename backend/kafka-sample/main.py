import os
from typing import Any, Dict, List

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

try:
    from kafka import KafkaProducer
except ImportError:  # pragma: no cover
    KafkaProducer = None

app = FastAPI(
    title="Kafka Sample Service",
    version="1.0.0",
    description="Simple Kafka producer sample for Azure AKS deployment and event-driven demos.",
)

KAFKA_BOOTSTRAP_SERVERS = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
KAFKA_TOPIC = os.getenv("KAFKA_TOPIC", "orders-events")


class EventPayload(BaseModel):
    order_id: str
    customer_id: str
    status: str
    total: float


def send_to_kafka(payload: Dict[str, Any]) -> Dict[str, Any]:
    if KafkaProducer is None:
        return {
            "status": "mocked",
            "message": "Kafka Python client not installed; event recorded in mock mode.",
            "payload": payload,
            "topic": KAFKA_TOPIC,
            "bootstrap_servers": KAFKA_BOOTSTRAP_SERVERS,
        }

    producer = KafkaProducer(
        bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS.split(","),
        value_serializer=lambda v: str(v).encode("utf-8"),
    )
    producer.send(KAFKA_TOPIC, payload)
    producer.flush()
    return {
        "status": "sent",
        "topic": KAFKA_TOPIC,
        "bootstrap_servers": KAFKA_BOOTSTRAP_SERVERS,
        "payload": payload,
    }


@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok", "service": "kafka-sample"}


@app.get("/topics")
def topics() -> Dict[str, Any]:
    return {"bootstrap_servers": KAFKA_BOOTSTRAP_SERVERS, "topic": KAFKA_TOPIC}


@app.post("/events/order")
def publish_order_event(payload: EventPayload) -> Dict[str, Any]:
    event = payload.model_dump()
    return send_to_kafka(event)


@app.post("/events/mock")
def publish_mock_event() -> Dict[str, Any]:
    event = {
        "order_id": "ORD-9999",
        "customer_id": "CUST-420",
        "status": "created",
        "total": 199.99,
    }
    return send_to_kafka(event)
