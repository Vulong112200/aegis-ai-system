import uuid
from datetime import datetime
from sqlalchemy import Column, String, Boolean, Integer, Float, DateTime, ForeignKey, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from pgvector.sqlalchemy import Vector
from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    cameras = relationship("Camera", back_populates="owner")
    persons = relationship("Person", back_populates="owner")

class Camera(Base):
    __tablename__ = "cameras"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(100), nullable=False)
    room = Column(String(100))
    stream_url = Column(String) # RTSP or Snapshot URL
    mode = Column(String(50), default="RECOGNITION_ON") # RECOGNITION_ON, SILENT, PRIVACY
    status = Column(String(50), default="ONLINE")
    cooldown_minutes = Column(Integer, default=10)
    
    owner = relationship("User", back_populates="cameras")
    sessions = relationship("RecognitionSession", back_populates="camera")

class Person(Base):
    __tablename__ = "persons"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(100), nullable=False) # E.g., "Dad", "Delivery Guy", or "Unknown_123"
    is_unknown = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="persons")
    embeddings = relationship("PersonEmbedding", back_populates="person", cascade="all, delete-orphan")
    recognized_sessions = relationship("RecognitionSession", back_populates="matched_person")

class PersonEmbedding(Base):
    __tablename__ = "person_embeddings"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    person_id = Column(UUID(as_uuid=True), ForeignKey("persons.id", ondelete="CASCADE"))
    # InsightFace generates 512-dimensional vectors
    embedding = Column(Vector(512), nullable=False)
    quality_score = Column(Float, nullable=False) # Sharpness/Frontal face score
    snapshot_url = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    person = relationship("Person", back_populates="embeddings")

class RecognitionSession(Base):
    __tablename__ = "recognition_sessions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    camera_id = Column(UUID(as_uuid=True), ForeignKey("cameras.id", ondelete="CASCADE"))
    matched_person_id = Column(UUID(as_uuid=True), ForeignKey("persons.id"), nullable=True)
    
    status = Column(String(50), default="PROCESSING") # PROCESSING, SUCCESS, FAILED_UNKNOWN, POSSIBLE_MATCH
    best_snapshot_url = Column(String, nullable=True)
    confidence_score = Column(Float, nullable=True)
    
    started_at = Column(DateTime, default=datetime.utcnow)
    ended_at = Column(DateTime, nullable=True)

    camera = relationship("Camera", back_populates="sessions")
    matched_person = relationship("Person", back_populates="recognized_sessions")
    attempts = relationship("RecognitionAttempt", back_populates="session", cascade="all, delete-orphan")

class RecognitionAttempt(Base):
    __tablename__ = "recognition_attempts"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id = Column(UUID(as_uuid=True), ForeignKey("recognition_sessions.id", ondelete="CASCADE"))
    attempt_number = Column(Integer, nullable=False)
    snapshot_url = Column(String, nullable=False)
    quality_score = Column(Float, nullable=True)
    is_valid = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    session = relationship("RecognitionSession", back_populates="attempts")