import cv2
import numpy as np

def validate_image_quality(image_bytes: bytes) -> dict:
    """Kiểm tra độ mờ và độ sáng của ảnh."""
    # Chuyển bytes thành mảng numpy rồi đọc bằng OpenCV
    np_arr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    
    if img is None:
        return {"is_valid": False, "reason": "Lỗi đọc ảnh"}

    # Chuyển sang ảnh xám để tính toán
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Tính độ sắc nét (Laplacian Variance)
    blur_score = cv2.Laplacian(gray, cv2.CV_64F).var()
    
    # Tính độ sáng trung bình
    brightness = np.mean(gray)
    
    # Điều kiện: Độ nét > 100 và không quá tối (< 50) hoặc chói (> 220)
    is_valid = blur_score > 100 and 50 < brightness < 220
    
    return {
        "is_valid": bool(is_valid),
        "blur_score": float(blur_score),
        "brightness": float(brightness),
        "image": img # Trả về ảnh đã decode để dùng cho bước sau
    }