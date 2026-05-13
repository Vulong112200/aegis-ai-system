from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class UserCreate(BaseModel):
    email: str
    password: str

class User(BaseModel):
    id: int
    email: str

    class Config:
        from_attributes = True

class CameraBase(BaseModel):
    name: str
    ip_address: str
    location: str

class CameraCreate(CameraBase):
    pass

class Camera(CameraBase):
    id: str
    is_online: bool

    class Config:
        from_attributes = True

class PersonBase(BaseModel):
    name: str
    image_url: Optional[str] = None
    is_known: bool

class Person(PersonBase):
    id: str
    face_vector: Optional[List[float]] = None

    class Config:
        from_attributes = True

class EventBase(BaseModel):
    camera_id: str
    person_id: str
    event_type: str
    confidence: float

class Event(EventBase):
    id: str
    timestamp: datetime

    class Config:
        from_attributes = True