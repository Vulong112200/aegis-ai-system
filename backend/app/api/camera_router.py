from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List

from app.database import get_db
from app.models import Camera

router = APIRouter()

# Schema để validate dữ liệu đầu vào khi tạo Camera
class CameraCreate(BaseModel):
    name: str
    room: str
    stream_url: str = ""

@router.get("/v1/cameras")
def get_all_cameras(db: Session = Depends(get_db)):
    """API lấy danh sách toàn bộ Camera của hệ thống"""
    cameras = db.query(Camera).all()
    
    result = []
    for cam in cameras:
        result.append({
            "id": str(cam.id),
            "name": cam.name,
            "room": cam.room,
            "status": cam.status,
            "mode": cam.mode,
            # Tạm thời trả về ảnh demo, sau này sẽ query lấy snapshot mới nhất từ bảng recognition_sessions
            "latest_snapshot_url": "https://images.unsplash.com/photo-1558036117-15d82a90b9b1?q=80&w=1000&auto=format&fit=crop"
        })
        
    return {"status": "success", "data": result}

@router.post("/v1/cameras")
def add_new_camera(payload: CameraCreate, db: Session = Depends(get_db)):
    """API để đăng ký một Camera mới vào hệ thống"""
    try:
        new_cam = Camera(
            name=payload.name,
            room=payload.room,
            stream_url=payload.stream_url
        )
        db.add(new_cam)
        db.commit()
        db.refresh(new_cam)
        return {"status": "success", "data": {"id": str(new_cam.id), "name": new_cam.name}}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))