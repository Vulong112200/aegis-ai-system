class CameraManager:
    def __init__(self):
        self.online_cameras = set()

    def mark_online(self, camera_id: str):
        self.online_cameras.add(camera_id)

    def mark_offline(self, camera_id: str):
        self.online_cameras.discard(camera_id)

    def is_online(self, camera_id: str) -> bool:
        return camera_id in self.online_cameras