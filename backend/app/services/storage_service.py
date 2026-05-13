import uuid
from supabase import create_client, Client
from app.config import settings

# Initialize Supabase client
supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
BUCKET_NAME = "snapshots"

def upload_snapshot(image_bytes: bytes, prefix: str = "unknown") -> str:
    """
    Uploads raw image bytes to Supabase Storage and returns the public URL.
    :param prefix: Folder inside the bucket (e.g., 'unknown', 'known', 'events')
    """
    # Generate a unique file name
    file_name = f"{prefix}/{uuid.uuid4().hex}.jpg"
    
    try:
        # Upload the file bytes to Supabase Storage
        res = supabase.storage.from_(BUCKET_NAME).upload(
            path=file_name,
            file=image_bytes,
            file_options={"content-type": "image/jpeg"}
        )
        
        # Retrieve and return the public URL so the Mobile App can display it
        public_url = supabase.storage.from_(BUCKET_NAME).get_public_url(file_name)
        return public_url

    except Exception as e:
        print(f"❌ Storage Upload Error: {e}")
        return None