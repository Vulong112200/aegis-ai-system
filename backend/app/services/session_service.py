from datetime import datetime, timedelta

class SessionService:
    def __init__(self):
        self.active_sessions = {}

    def create_session(self, camera_id: str, person_id: str):
        session_key = f"{camera_id}_{person_id}"
        self.active_sessions[session_key] = datetime.now()

    def is_in_cooldown(self, camera_id: str, person_id: str, cooldown_minutes: int = 5) -> bool:
        session_key = f"{camera_id}_{person_id}"
        if session_key in self.active_sessions:
            last_seen = self.active_sessions[session_key]
            if datetime.now() - last_seen < timedelta(minutes=cooldown_minutes):
                return True
        return False