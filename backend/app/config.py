import os
from dotenv import load_dotenv
from pydantic_settings import BaseSettings

load_dotenv()

class Config:
    DATABASE_URL = os.getenv("DATABASE_URL")
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
    JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("JWT_ACCESS_TOKEN_EXPIRE_MINUTES", 30))
    REDIS_URL = os.getenv("REDIS_URL")
    

class Settings(BaseSettings):
    PROJECT_NAME: str = "Aegis AI System API"
    VERSION: str = "1.0.0"
    
    # Database
    DATABASE_URL: str
    
    # Security
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 43200
    
    # AI Thresholds
    CONFIDENCE_THRESHOLD: float = 0.85
    POSSIBLE_MATCH_THRESHOLD: float = 0.65
    MAX_RECOGNITION_ATTEMPTS: int = 5
    COOLDOWN_MINUTES: int = 10

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()