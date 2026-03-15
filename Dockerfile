FROM python:3.12-slim

LABEL org.opencontainers.image.source=https://github.com/snowmirage/lspeak-wyoming
LABEL org.opencontainers.image.description="OpenAI-compatible TTS server bridging to Wyoming XTTS"

RUN pip install --no-cache-dir fastapi uvicorn pydantic

COPY lspeak-server /app/lspeak-server
COPY preprocess.py /app/preprocess.py

WORKDIR /app

ENV WYOMING_HOST=10.2.0.123
ENV WYOMING_PORT=10200
ENV LSPEAK_PORT=8820

EXPOSE 8820

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8820/health')" || exit 1

CMD python3 lspeak-server --host 0.0.0.0 --port ${LSPEAK_PORT}
