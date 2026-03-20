# Milvus

Production-grade open-source vector database built for scalable similarity search. Supports billion-scale vector data with high performance.

## What It Does

- Vector similarity search (L2, IP, cosine)
- Hybrid search combining vector and scalar filtering
- Multi-vector index support (IVF, HNSW, DiskANN)
- Scalar field filtering and metadata queries
- Standalone mode for single-node deployments
- gRPC and RESTful API interfaces

## Quick Start

```bash
dream enable milvus
dream start milvus
```

Milvus listens on **port 19530** (gRPC) by default. Use any Milvus SDK to connect.

### Python Quick Start

```python
from pymilvus import connections, Collection

connections.connect(host="localhost", port="19530")
```

## API Usage

### Health Check

```bash
docker exec dream-milvus curl -sf http://localhost:9091/healthz
```

> **Note:** The health endpoint (port 9091) is internal to the container and not exposed to the host. DreamServer monitors health automatically via the compose healthcheck.

### Create Collection (via REST)

```bash
curl -X POST http://localhost:19530/v2/vectordb/collections/create \
  -H "Content-Type: application/json" \
  -d '{
    "collectionName": "my_collection",
    "dimension": 768
  }'
```

### Insert Vectors (via REST)

```bash
curl -X POST http://localhost:19530/v2/vectordb/entities/insert \
  -H "Content-Type: application/json" \
  -d '{
    "collectionName": "my_collection",
    "data": [{"vector": [0.1, 0.2, ...]}]
  }'
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MILVUS_PORT` | `19530` | External gRPC port |
| `MODE` | `standalone` | Deployment mode (`standalone` or `cluster`) |

## Data Persistence

- `./data/milvus/` — Index files, metadata, and WAL logs
