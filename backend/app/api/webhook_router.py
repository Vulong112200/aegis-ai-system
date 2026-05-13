import sys
import os
from fastapi import APIRouter, UploadFile, File, HTTPException, BackgroundTasks
from datetime import datetime
import uuid

# Thêm đường dẫn thư mục gốc vào hệ thống để import ai_engine
sys.path.append(os.path.abspath(
    os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        '..', '..', '..'
    )
))

from ai_engine.engine.image_validator import validate_image_quality
from ai_engine.engine.ai_core import ai_system

# Thêm import cho Database và Recognition Service
from app.database import SessionLocal
from app.services.recognition_service import find_matching_person

from app.services.storage_service import upload_snapshot
from app.models import Person, PersonEmbedding

router = APIRouter()

def process_image_background(camera_id: str, image_bytes: bytes, session_id: str):
    """Hàm này sẽ chạy ngầm sau khi API đã trả về HTTP 200 cho Camera"""
    print(f"\n[{session_id}] ⚙️ AI đang xử lý ảnh từ {camera_id}...")
    
    # 1. Lọc ảnh rác
    quality = validate_image_quality(image_bytes)
    if not quality["is_valid"]:
        print(f"[{session_id}] ❌ Ảnh bị loại bỏ. Blur: {quality['blur_score']:.1f}, Brightness: {quality['brightness']:.1f}")
        return

    print(f"[{session_id}] ✨ Ảnh đạt chất lượng. Đang đưa vào AI nhận diện...")
    
    # 2. Đưa vào Lõi AI
    embedding, msg = ai_system.extract_face_vector(quality["image"])
    
    if embedding is not None:
        # 3. KẾT NỐI DATABASE VÀ TÌM KIẾM KHUÔN MẶT
        db = SessionLocal()
        try:
            person, confidence = find_matching_person(db, embedding)
            
            if person:
                print(f"[{session_id}] 🎯 NHẬN DIỆN THÀNH CÔNG: {person.name} (Tỉ lệ giống: {confidence*100:.1f}%)")
                # Nếu là người quen, ta có thể lưu ảnh vào folder 'events'
                # snapshot_url = upload_snapshot(image_bytes, prefix="events")
            else:
                # ==========================================
                # XỬ LÝ KHI PHÁT HIỆN NGƯỜI LẠ (UNKNOWN)
                # ==========================================
                print(f"[{session_id}] 👤 NGƯỜI LẠ! Đang lưu thông tin lên Cloud...")
                
                # Bước A: Upload ảnh lên Supabase Storage
                snapshot_url = upload_snapshot(image_bytes, prefix="unknown")
                
                if snapshot_url:
                    # Bước B: Tạo hồ sơ Người Lạ trong bảng persons
                    unknown_name = f"Unknown_{session_id[:8]}"
                    new_unknown = Person(
                        name=unknown_name,
                        is_unknown=True
                    )
                    db.add(new_unknown)
                    db.commit()
                    db.refresh(new_unknown)

                    # Bước C: Lưu Vector và Link Ảnh vào bảng person_embeddings
                    new_embedding = PersonEmbedding(
                        person_id=new_unknown.id,
                        embedding=embedding.tolist(),
                        quality_score=quality["blur_score"],
                        snapshot_url=snapshot_url
                    )
                    db.add(new_embedding)
                    db.commit()

                    print(f"[{session_id}] ✅ Đã lưu người lạ: {unknown_name}")
                    print(f"[{session_id}] 🔗 Link ảnh: {snapshot_url}")
                else:
                    print(f"[{session_id}] ❌ Lỗi upload ảnh lên Cloud, bỏ qua lưu DB.")
                
        except Exception as e:
            print(f"[{session_id}] ❌ Lỗi Database: {str(e)}")
            db.rollback()
        finally:
            db.close()
    else:
        print(f"[{session_id}] ⚠️ {msg}")


@router.post("/v1/cameras/{camera_id}/snapshot")
async def receive_camera_snapshot(
    camera_id: str,
    background_tasks: BackgroundTasks, # Thêm tham số này của FastAPI
    file: UploadFile = File(...),
):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")

    image_bytes = await file.read()
    session_id = str(uuid.uuid4())
    
    print(f"[{datetime.now().strftime('%H:%M:%S')}] 📸 Nhận ảnh từ {camera_id}. Giao việc cho AI Worker...")

    # Đưa tác vụ xử lý AI vào Background, API sẽ không bị block và trả kết quả ngay
    background_tasks.add_task(process_image_background, camera_id, image_bytes, session_id)
    
    return {
        "status": "success",
        "message": "Snapshot received. AI is processing in background.",
        "session_id": session_id
    }