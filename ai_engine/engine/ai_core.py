import mediapipe as mp
import insightface
from insightface.app import FaceAnalysis

class AICore:
    def __init__(self):
        self.mp_face_detection = mp.solutions.face_detection.FaceDetection(
            model_selection=0, min_detection_confidence=0.5)
        self.face_app = FaceAnalysis(name='buffalo_l')
        self.face_app.prepare(ctx_id=0, det_size=(640, 640))

    def detect_faces_mp(self, image):
        results = self.mp_face_detection.process(image)
        return results.detections if results.detections else []

    def extract_face_vector(self, image):
        faces = self.face_app.get(image)
        if faces:
            return faces[0].embedding
        return None