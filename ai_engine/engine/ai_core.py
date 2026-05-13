import cv2
import numpy as np
import mediapipe as mp
from insightface.app import FaceAnalysis

class SmartAIEngine:
    def __init__(self):
        print("🧠 [AI Engine] Đang khởi động MediaPipe...")
        self.mp_face_detection = mp.solutions.face_detection
        self.detector = self.mp_face_detection.FaceDetection(
            model_selection=1, # 1 cho camera xa, 0 cho camera gần
            min_detection_confidence=0.6
        )
        
        print("🧠 [AI Engine] Đang khởi động InsightFace (Buffalo_L)...")
        # Initialize InsightFace. It will download models on first run.
        # Initialize InsightFace. Bắt buộc phải có 'detection' để align khuôn mặt.
        self.app = FaceAnalysis(
            name='buffalo_l', 
            allowed_modules=['detection', 'recognition'],
            providers=['CPUExecutionProvider'] # Thêm dòng này để tắt cảnh báo tìm Card màn hình
        )
        self.app.prepare(ctx_id=0, det_size=(640, 640)) # ctx_id=0 for CPU
        print("✅ [AI Engine] Hệ thống AI đã sẵn sàng!")

    def extract_face_vector(self, image: np.ndarray):
        """Tìm mặt và trả về Vector 512 chiều."""
        # 1. Chạy MediaPipe trước (Rất nhẹ)
        rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = self.detector.process(rgb_image)
        
        if not results.detections:
            return None, "Không tìm thấy khuôn mặt (MediaPipe)"

        # 2. Nếu có mặt, chạy InsightFace (Nặng hơn) để lấy Vector
        faces = self.app.get(image)
        
        if len(faces) == 0:
            return None, "InsightFace không trích xuất được vector"

        # Lấy khuôn mặt to nhất trong khung hình (tránh nhận diện sai người phía xa)
        largest_face = max(faces, key=lambda f: f.bbox[2] * f.bbox[3])
        
        # Trả về mảng 512 số thực (Face Embedding)
        return largest_face.embedding, "Thành công"

# Khởi tạo instance duy nhất (Singleton) để dùng chung, tránh load lại model nhiều lần
ai_system = SmartAIEngine()