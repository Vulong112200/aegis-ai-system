# Aegis AI System

Event-driven video snapshot ingestion + AI processing pipeline.

## High-level architecture
- **Edge devices (cameras)**: send snapshot HTTP POST when motion/person-like event detected.
- **API Gateway (FastAPI)**: validates request, creates an ingestion record, enqueues a job.
- **Message Queue (Redis)**: decouples ingestion from heavy AI work.
- **AI Engine (Celery workers)**: runs MediaPipe/InsightFace (placeholder scaffolding), stores embeddings/events.
- **Realtime (WebSockets)**: pushes updates to mobile.
- **Mobile app (Flutter)**: dashboard/timeline UI.

## Run (local / dev)
Use `devops/docker-compose.yml` (scaffolding included).

```bash
docker compose -f devops/docker-compose.yml up --build
```

## Notes
- This repo is scaffolded from scratch. Model weights are **not** included.
- The `ai_engine` module contains placeholders and safe import patterns.

