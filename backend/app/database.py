from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.config import settings

# Create engine optimized for cloud environments (handle disconnects)
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # Automatically verify connections before using them
    pool_size=5,         # Keep connections low for free tier DBs
    max_overflow=10
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    """Dependency for FastAPI to get DB session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()