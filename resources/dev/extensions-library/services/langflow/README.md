# Langflow

Visual LLM workflow builder that lets you create complex AI workflows with a drag-and-drop interface. Supports LangChain components, custom components, and real-time testing.

## What It Does

- Visual drag-and-drop workflow builder for LLM pipelines
- Build RAG (Retrieval Augmented Generation) pipelines visually
- Create and test AI agents with no code
- LangChain component library built in
- Real-time testing and debugging of workflows
- Export workflows as Python code or API endpoints

## Quick Start

```bash
dream enable langflow
dream start langflow
```

Open **http://localhost:7802** to access the Langflow UI.

## API Usage

### Run a Flow

```bash
curl -X POST http://localhost:7802/api/v1/run/<flow_id> \
  -H "Content-Type: application/json" \
  -d '{"input_value": "Hello, what can you help me with?"}'
```

### Health Check

```bash
curl http://localhost:7802/health
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LANGFLOW_HOST` | `0.0.0.0` | Bind address |
| `LANGFLOW_PORT` | `7802` | External port |
| `LLM_API_URL` | `http://llama-server:8080` | Backend LLM API endpoint |

## Data Persistence

- `./data/langflow/` — Flows, components, and configuration
