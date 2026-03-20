# LocalAI

OpenAI-compatible local inference API. Run LLMs, generate images, audio, video, and clone voices — all through the same API format as OpenAI, entirely on your own hardware.

## What It Does

- Text generation via OpenAI-compatible `/v1/chat/completions` API
- Image generation with local diffusion models
- Audio generation and transcription
- Video generation with local models
- Voice cloning for text-to-speech
- Drop-in replacement for OpenAI API in existing applications

## Quick Start

```bash
dream enable localai
dream start localai
```

Open **http://localhost:7803** to access the LocalAI web interface.

## API Usage

### Chat Completion (OpenAI-compatible)

```bash
curl -X POST http://localhost:7803/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### List Available Models

```bash
curl http://localhost:7803/v1/models
```

### Health Check

```bash
curl http://localhost:7803/healthz
```

## VRAM Requirements

| Feature | VRAM |
|---------|------|
| Text Generation | 4 GB |
| Audio Generation | 4 GB |
| Voice Cloning | 4 GB |
| Image Generation | 8 GB |
| Video Generation | 16 GB |

**GPU:** AMD or NVIDIA. CPU fallback available (slower).

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LOCALAI_EXTERNAL_PORT` | `7803` | External port |
| `MODELS_PATH` | `/models` | Path to model files |
| `CONFIG_PATH` | `/builds` | Path to build configs |
| `LLM_API_URL` | `http://llama-server:8080` | Backend LLM API endpoint |

## Data Persistence

- `./data/localai/models/` — Downloaded model files
- `./data/localai/builds/` — Build configurations and cached artifacts
