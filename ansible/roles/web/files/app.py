from flask import Flask, Response, request
from prometheus_client import generate_latest, Histogram, Counter, Gauge
import time
from pymongo import MongoClient

app = Flask(__name__)

REQUEST_LATENCY = Histogram('flask_request_latency_seconds', 'Request latency', buckets=[0.1, 0.3, 0.5, 1, 2, 5])
REQUEST_COUNT = Counter('flask_request_count', 'Total HTTP requests', ['method', 'endpoint', 'http_status'])
HEALTH_STATUS = Gauge('mongo_up', 'MongoDB availability')

client = MongoClient("mongodb://mongo:27017/", serverSelectionTimeoutMS=1000)

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    resp_time = time.time() - request.start_time
    REQUEST_LATENCY.observe(resp_time)
    REQUEST_COUNT.labels(method=request.method, endpoint=request.path, http_status=response.status_code).inc()
    return response

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')

@app.route('/')
def index():
    return "Welcome to the SRE-monitored Flask App with MongoDB!"

@app.route('/health')
def health():
    try:
        client.admin.command('ping')
        HEALTH_STATUS.set(1)
        return "OK", 200
    except:
        HEALTH_STATUS.set(0)
        return "MongoDB connection failed", 500

@app.route('/slow')
def slow():
    time.sleep(5)
    return "Slow response", 200

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

# filepath: ansible/roles/web/files/test_app.py
def test_example():
    assert 1 + 1 == 2