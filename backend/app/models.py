from sqlalchemy import Column, Integer, String, Boolean, DateTime, Float, Text
from sqlalchemy.dialects.postgresql import ARRAY
from .database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)

class Camera(Base):
    __tablename__ = "cameras"
    id = Column(String, primary_key=True, index=True)
    name = Column(String)
    ip_address = Column(String)
    is_online = Column(Boolean, default=True)
    location = Column(String)

class Person(Base):
    __tablename__ = "persons"
    id = Column(String, primary_key=True, index=True)
    name = Column(String)
    image_url = Column(String, nullable=True)
    is_known = Column(Boolean, default=False)
    face_vector = Column(ARRAY(Float), nullable=True)

class Event(Base):
    __tablename__ = "events"
    id = Column(String, primary_key=True, index=True)
    camera_id = Column(String)
    person_id = Column(String)
    timestamp = Column(DateTime)
    event_type = Column(String)
    confidence = Column(Float)