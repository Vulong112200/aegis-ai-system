import sys
import os
from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Depends
from sqlalchemy.orm import Session
import numpy as np

# Import DB và Models
from app.database import get_db
from app.models import Person, PersonEmbedding

# Import AI Engine
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')))
from ai_engine.engine.image_validator import validate_image_quality
from ai_engine.engine.ai_core import ai_system
from pydantic import BaseModel

router = APIRouter()

@router.post("/v1/persons/register")
async def register_new_person(
    name: str = Form(..., description="Tên của người cần nhận diện"),
    file: UploadFile = File(..., description="Ảnh rõ nét khuôn mặt"),
    db: Session = Depends(get_db)
):
    """
    API dùng để thêm một người quen mới vào hệ thống.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Vui lòng tải lên một file ảnh.")

    image_bytes = await file.read()

    # 1. Kiểm tra chất lượng ảnh đăng ký (Yêu cầu khắt khe hơn ảnh camera thường)
    quality = validate_image_quality(image_bytes)
    if not quality["is_valid"]:
        raise HTTPException(
            status_code=400, 
            detail=f"Ảnh không đạt chuẩn để đăng ký. Độ nét: {quality['blur_score']:.1f} (Cần > 100)."
        )

    # 2. Trích xuất Vector khuôn mặt
    embedding, msg = ai_system.extract_face_vector(quality["image"])
    
    if embedding is None:
        raise HTTPException(status_code=400, detail=f"Không thể nhận diện khuôn mặt: {msg}")

    # 3. Lưu vào Database
    try:
        # Tạo record Người
        new_person = Person(
            name=name,
            is_unknown=False
        )
        db.add(new_person)
        db.commit() # Commit để sinh ra ID
        db.refresh(new_person)

        # Tạo record Vector lưu cùng
        new_embedding = PersonEmbedding(
            person_id=new_person.id,
            embedding=embedding.tolist(), # pgvector nhận list số thực
            quality_score=quality["blur_score"],
            snapshot_url="local_upload" # Tạm thời để string tĩnh, sau này sẽ thay bằng URL thật trên Supabase Storage
        )
        db.add(new_embedding)
        db.commit()

        return {
            "status": "success",
            "message": f"Đã đăng ký thành công cho {name}",
            "person_id": str(new_person.id)
        }

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Lỗi Database: {str(e)}")
    
# Schema để nhận data từ Request Body
class PersonUpdate(BaseModel):
    name: str

@router.put("/v1/persons/{person_id}")
async def update_person_name(
    person_id: str,
    payload: PersonUpdate,
    db: Session = Depends(get_db)
):
    """
    API dùng để đổi tên người lạ thành người quen (hoặc sửa tên người quen).
    """
    # Tìm người trong Database
    person = db.query(Person).filter(Person.id == person_id).first()
    
    if not person:
        raise HTTPException(status_code=404, detail="Không tìm thấy người này trong hệ thống.")

    # Cập nhật thông tin
    old_name = person.name
    person.name = payload.name
    person.is_unknown = False  # Đánh dấu đây không còn là người lạ nữa
    
    try:
        db.commit()
        return {
            "status": "success",
            "message": f"Đã đổi tên từ '{old_name}' thành '{payload.name}'",
            "person_id": str(person.id)
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Lỗi Database: {str(e)}")