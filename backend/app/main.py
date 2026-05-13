from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api import auth_router, camera_router, webhook_router

app = FastAPI(title="Aegis AI System API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(camera_router, prefix="/api/v1/cameras", tags=["cameras"])
app.include_router(webhook_router, prefix="/api/v1/webhook", tags=["webhook"])

@app.get("/")
async def root():
    return {"message": "Aegis AI System API"}