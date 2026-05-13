from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.database import engine, Base
from sqlalchemy import text
from app.api import webhook_router # <-- THÊM DÒNG NÀY

# IMPORTANT: Ensure the pgvector extension is created in Supabase BEFORE creating tables
with engine.connect() as connection:
    connection.execute(text('CREATE EXTENSION IF NOT EXISTS vector;'))
    connection.commit()

# Create all tables (In production, use Alembic migrations instead)
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Production-grade AI Smart Camera API"
)

# Setup CORS for mobile app & dashboard
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def health_check():
    """System health check endpoint."""
    return {
        "status": "online",
        "service": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "edge_ready": True
    }

# TODO: Include routers here (e.g., app.include_router(auth_router.router))
app.include_router(webhook_router.router, prefix="/api", tags=["Webhooks"])