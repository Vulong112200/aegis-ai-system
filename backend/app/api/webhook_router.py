from fastapi import APIRouter, File, UploadFile
from celery_app import process_image

router = APIRouter()

@router.post("/snapshot")
async def receive_snapshot(camera_id: str, file: UploadFile = File(...)):
    # Save file temporarily or process
    # Send to Celery queue
    task = process_image.delay(camera_id, file.filename)
    return {"task_id": task.id, "status": "processing"}