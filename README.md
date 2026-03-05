# lspeak-wyoming

Drop-in replacement for [lspeak](https://github.com/nickpending/lspeak) that routes TTS through a [Wyoming](https://github.com/rhasspy/wyoming) XTTS server.

Built as a shim for [Clarvis](https://github.com/nickpending/clarvis) — Clarvis expects `lspeak` on PATH, this script accepts the same CLI interface but sends text to a Wyoming TTS server instead of Kokoro/ElevenLabs.

## Why

- Use your own fine-tuned XTTS voice (e.g., Jarvis) with Clarvis
- No Python 3.13+ requirement (lspeak needs it, this doesn't)
- No ElevenLabs API key or costs
- Single TTS engine for everything (HA voice pipeline + coding agent)

## Install

```bash
git clone https://github.com/snowmirage/lspeak-wyoming.git
cd lspeak-wyoming
chmod +x lspeak
ln -sf "$(pwd)/lspeak" ~/.local/bin/lspeak
```

## Configuration

Edit the server address at the top of `lspeak`:

```python
WYOMING_HOST = "10.2.0.123"  # Your Wyoming TTS server
WYOMING_PORT = 10200
```

Or set environment variables (TODO).

## Usage

```bash
# Direct text
lspeak "Sir, the build completed successfully."

# Piped input
echo "All tests passed." | lspeak

# From file
lspeak -f notes.txt

# Save to WAV
lspeak -o output.wav "Hello Sir."
```

## lspeak CLI Compatibility

Accepts all lspeak flags for drop-in compatibility. Most are no-ops since Wyoming XTTS handles everything server-side:

| Flag | Status |
|------|--------|
| `--provider` | Accepted, ignored (always Wyoming) |
| `--voice` | Accepted, passed to Wyoming |
| `--no-cache` | Accepted, ignored |
| `--cache-threshold` | Accepted, ignored |
| `-f, --file` | Supported |
| `-o, --output` | Supported (saves WAV) |
| `--list-voices` | Stub |
| `--debug` | Supported |

## lspeak-server (OpenAI-compatible TTS API)

An HTTP server that exposes an OpenAI-compatible `/v1/audio/speech` endpoint, bridging to Wyoming XTTS. Use it with Open WebUI, or any client that supports custom TTS endpoints.

### Docker (recommended)

```bash
docker run -d \
  --name lspeak-server \
  -p 8820:8820 \
  -e WYOMING_HOST=10.2.0.123 \
  -e WYOMING_PORT=10200 \
  ghcr.io/snowmirage/lspeak-server:latest
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WYOMING_HOST` | `10.2.0.123` | Wyoming TTS server IP |
| `WYOMING_PORT` | `10200` | Wyoming TTS server port |
| `LSPEAK_PORT` | `8820` | HTTP listen port |

### Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v1/audio/speech` | POST | OpenAI-compatible TTS. Body: `{"input": "text", "voice": "jarvis"}` |
| `/v1/audio/speech/voices` | GET | List available voices |
| `/health` | GET | Health check |

### Open WebUI Configuration

In Open WebUI Admin → Settings → Audio → TTS:
- Engine: **Custom TTS**
- Base URL: `http://<lspeak-server-ip>:8820/v1`

## Requirements

### lspeak CLI
- **Python 3.10+** (uses only stdlib — no pip dependencies)
- **alsa-utils** for audio playback (`aplay`) or **powershell.exe** on WSL
- A running [Wyoming TTS server](https://github.com/rhasspy/wyoming) (e.g., wyoming-xtts, wyoming-piper)

### lspeak-server
- **Python 3.10+** with fastapi, uvicorn
- Or just use the Docker image

## License

MIT
