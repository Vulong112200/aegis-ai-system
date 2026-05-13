import cv2
import requests
import time

# Cấu hình
CAMERA_ID = "laptop-webcam-001" # ID giả lập của camera
API_URL = f"http://127.0.0.1:8000/api/v1/cameras/{CAMERA_ID}/snapshot"

def main():
    print("Khởi động Webcam Laptop...")
    cap = cv2.VideoCapture(0) # Số 0 là webcam mặc định của máy tính
    
    if not cap.isOpened():
        print("Lỗi: Không thể mở webcam.")
        return

    print("✅ Bấm [SPACE] để giả lập phát hiện chuyển động và gửi ảnh lên Server.")
    print("✅ Bấm [Q] để thoát.")

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Hiển thị luồng video
        cv2.imshow("Aegis Edge Camera Simulator", frame)
        key = cv2.waitKey(1) & 0xFF

        # Nếu nhấn phím Space
        if key == ord(' '):
            print("🚀 Phát hiện chuyển động! Đang gửi ảnh lên Server...")
            
            # Chuyển frame (numpy array) thành định dạng JPEG
            _, buffer = cv2.imencode('.jpg', frame)
            
            # Đóng gói thành Multipart Form Data để gửi qua HTTP POST
            files = {
                'file': ('snapshot.jpg', buffer.tobytes(), 'image/jpeg')
            }
            
            try:
                start_time = time.time()
                response = requests.post(API_URL, files=files)
                latency = (time.time() - start_time) * 1000
                
                if response.status_code == 200:
                    print(f"✅ Gửi thành công! (Độ trễ: {latency:.0f}ms)")
                    print(f"   Phản hồi từ Server: {response.json()}")
                else:
                    print(f"❌ Lỗi Server: {response.status_code} - {response.text}")
            except Exception as e:
                print(f"❌ Không thể kết nối tới Server: {e}")

        # Thoát nếu nhấn phím Q
        elif key == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()