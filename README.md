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

## Requirements

- Python 3.10+
- `aplay` (ALSA utils) for audio playback on Linux
- A running Wyoming TTS server

## License

MIT
