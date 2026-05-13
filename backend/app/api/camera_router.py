from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import Camera
from ..schemas import CameraCreate, Camera

router = APIRouter()

@router.get("/", response_model=list[Camera])
def get_cameras(db: Session = Depends(get_db)):
    cameras = db.query(Camera).all()
    return cameras

@router.post("/", response_model=Camera)
def create_camera(camera: CameraCreate, db: Session = Depends(get_db)):
    db_camera = Camera(**camera.dict())
    db.add(db_camera)
    db.commit()
    db.refresh(db_camera)
    return db_camera

@router.put("/{camera_id}", response_model=Camera)
def update_camera(camera_id: str, camera: CameraCreate, db: Session = Depends(get_db)):
    db_camera = db.query(Camera).filter(Camera.id == camera_id).first()
    if not db_camera:
        raise HTTPException(status_code=404, detail="Camera not found")
    for key, value in camera.dict().items():
        setattr(db_camera, key, value)
    db.commit()
    db.refresh(db_camera)
    return db_camera