from sqlalchemy.orm import Session
from sqlalchemy import select
from app.models import Person, PersonEmbedding
import numpy as np

def find_matching_person(db: Session, embedding: np.ndarray, threshold: float = 0.45):
    """
    So sánh vector khuôn mặt mới với toàn bộ Database.
    InsightFace (buffalo_l) thường dùng threshold ~0.45 cho độ tương đồng Cosine.
    """
    # Chuyển numpy array của AI thành list số thực để pgvector hiểu được
    vector_list = embedding.tolist()

    # Dùng pgvector: Tính khoảng cách Cosine (cosine_distance) 
    # Khoảng cách càng nhỏ (gần 0) -> Càng giống nhau
    stmt = select(
        PersonEmbedding, 
        PersonEmbedding.embedding.cosine_distance(vector_list).label('distance')
    ).join(Person).order_by('distance').limit(1)

    result = db.execute(stmt).first()

    if result:
        embedding_record, distance = result
        # Độ tự tin (Confidence/Similarity) = 1 - Khoảng cách
        confidence = 1.0 - distance 

        if confidence >= threshold:
            return embedding_record.person, confidence

    return None, 0.0