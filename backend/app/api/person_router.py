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
    
from typing import List
from sqlalchemy.orm import joinedload
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


# 1. Định nghĩa Schema nhận Data
class MergePersonsRequest(BaseModel):
    source_person_ids: List[str]  # Danh sách ID của các Unknown Persons cần gộp

# 2. Viết API Gộp
@router.post("/v1/persons/{target_person_id}/merge")
async def merge_unknowns_to_person(
    target_person_id: str,
    payload: MergePersonsRequest,
    db: Session = Depends(get_db)
):
    """
    API để gộp nhiều khuôn mặt (Vector) của người lạ vào một người quen.
    - Chuyển toàn bộ Vector từ source_person_ids sang target_person_id.
    - Xóa các bản ghi source_person_ids khỏi bảng persons.
    """
    if not payload.source_person_ids:
        raise HTTPException(status_code=400, detail="Danh sách người cần gộp trống.")

    # 1. Kiểm tra Người đích (Target) có tồn tại không
    target_person = db.query(Person).filter(Person.id == target_person_id).first()
    if not target_person:
        raise HTTPException(status_code=404, detail="Không tìm thấy người dùng đích.")

    try:
        # 2. Chuyển chủ sở hữu (person_id) của toàn bộ Vector sang Target
        updated_rows = db.query(PersonEmbedding).filter(
            PersonEmbedding.person_id.in_(payload.source_person_ids)
        ).update(
            {"person_id": target_person_id},
            synchronize_session=False # Tối ưu hóa khi update số lượng lớn
        )

        # 3. Xóa các bản ghi rác (Unknown persons) trong bảng persons
        deleted_rows = db.query(Person).filter(
            Person.id.in_(payload.source_person_ids)
        ).delete(synchronize_session=False)

        # 4. Lưu thay đổi
        db.commit()

        return {
            "status": "success",
            "message": f"Đã gộp thành công {updated_rows} vector vào người dùng '{target_person.name}'. Đã xóa {deleted_rows} hồ sơ người lạ.",
            "target_person_id": target_person_id
        }

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Lỗi Database: {str(e)}")
    
# ----------------------------------------------------
# 1. API Lấy danh sách NGƯỜI QUEN (Đổ vào Combobox)
# ----------------------------------------------------
@router.get("/v1/persons/known")
async def get_known_persons(db: Session = Depends(get_db)):
    """
    Trả về danh sách người quen (is_unknown = False).
    Sử dụng để hiển thị Combobox/Dropdown trên App UI.
    """
    persons = db.query(Person).filter(Person.is_unknown == False).all()
    
    result = []
    for p in persons:
        result.append({
            "id": str(p.id),
            "name": p.name
        })
        
    return {"status": "success", "data": result}

# ----------------------------------------------------
# 2. API Lấy danh sách NGƯỜI LẠ (Đổ vào Grid Checkbox)
# ----------------------------------------------------
@router.get("/v1/persons/unknown")
async def get_unknown_persons(db: Session = Depends(get_db)):
    """
    Trả về danh sách người lạ kèm theo ảnh chụp của họ.
    Sử dụng để hiển thị danh sách dạng lưới (Grid) cho admin tick chọn.
    """
    # Lấy người lạ kèm theo ảnh (embeddings) của họ
    unknowns = db.query(Person).options(joinedload(Person.embeddings)).filter(Person.is_unknown == True).all()
    
    result = []
    for u in unknowns:
        # Lấy link ảnh đầu tiên làm ảnh đại diện
        snapshot_url = None
        if u.embeddings and len(u.embeddings) > 0:
            snapshot_url = u.embeddings[0].snapshot_url
            
        result.append({
            "id": str(u.id),
            "name": u.name,
            "snapshot_url": snapshot_url,
            "created_at": u.created_at
        })
        
    return {"status": "success", "data": result}