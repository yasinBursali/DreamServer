# Forge / A1111

Forge (based on Automatic1111) is the original Stable Diffusion web UI. Features extensive model support, extensions, inpainting, outpainting, and professional-grade image generation capabilities. GPU required.

## What It Does

- Full Stable Diffusion image generation with advanced settings
- Inpainting with mask support
- Outpainting beyond image boundaries
- High-resolution upscaling with multiple engines
- Extensive extension ecosystem
- REST API for integration with external workflows

## Quick Start

```bash
dream enable forge
dream start forge
```

Open **http://localhost:7861** to access the Forge web UI.

**Note:** First startup may download several GB of model files. Subsequent starts are instant.

## API Usage

### Generate via txt2img API

```bash
curl -X POST http://localhost:7861/sdapi/v1/txt2img \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "a photo of a cat in a garden",
    "steps": 20,
    "width": 512,
    "height": 512
  }'
```

### Check Progress

```bash
curl http://localhost:7861/sdapi/v1/progress
```

## VRAM Requirements

| Feature | VRAM |
|---------|------|
| Image Generation | 8 GB |
| Inpainting | 8 GB |
| Outpainting | 8 GB |
| Upscaling | 4 GB |

**GPU:** NVIDIA only.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FORGE_PORT` | `7861` | External port |
| `FORGE_PORT_HOST` | `7861` | Internal port binding |
| `FORGE_ARGS` | `--api --listen` | Launch arguments |
| `AUTO_UPDATE` | `false` | Auto-update on startup |

## Data Persistence

- `./data/forge/models/` — Stable Diffusion models, LoRAs, VAEs
- `./data/forge/outputs/` — Generated images
