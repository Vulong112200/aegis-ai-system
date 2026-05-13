from celery import Celery
from .ai_core import AICore
from .image_validator import ImageValidator
from .vector_db import VectorDB
import cv2
import numpy as np

app = Celery('ai_engine')

ai_core = AICore()
vector_db = VectorDB("postgresql://user:pass@localhost:5432/aegis_db")

@app.task
def process_image(camera_id, image_path):
    image = cv2.imread(image_path)
    
    # Validate image
    if ImageValidator.is_blurry(image) or ImageValidator.is_too_dark(image):
        return {"status": "rejected", "reason": "poor_quality"}
    
    # Detect faces
    faces = ai_core.detect_faces_mp(image)
    if not faces:
        return {"status": "no_faces"}
    
    # Extract face vector
    face_vector = ai_core.extract_face_vector(image)
    if face_vector is None:
        return {"status": "extraction_failed"}
    
    # Search for matches
    matches = vector_db.find_similar_faces(face_vector)
    if matches:
        # Known person
        person_id = matches[0][0]
        return {"status": "recognized", "person_id": person_id, "confidence": 1 - matches[0][2]}
    else:
        # Unknown person
        return {"status": "unknown", "face_vector": face_vector.tolist()}