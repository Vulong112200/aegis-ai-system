import psycopg2
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

class VectorDB:
    def __init__(self, db_url):
        self.conn = psycopg2.connect(db_url)

    def find_similar_faces(self, face_vector, threshold=0.6):
        with self.conn.cursor() as cur:
            cur.execute("""
                SELECT id, name, face_vector <=> %s::vector as distance
                FROM persons
                WHERE face_vector IS NOT NULL
                ORDER BY face_vector <=> %s::vector
                LIMIT 10
            """, (face_vector.tolist(), face_vector.tolist()))
            results = cur.fetchall()
            return [r for r in results if r[2] < (1 - threshold)]  # Cosine distance to similarity

    def save_face_vector(self, person_id, face_vector):
        with self.conn.cursor() as cur:
            cur.execute("""
                UPDATE persons SET face_vector = %s WHERE id = %s
            """, (face_vector.tolist(), person_id))
            self.conn.commit()