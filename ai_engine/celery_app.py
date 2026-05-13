from celery import Celery
from engine.tasks import process_image

app = Celery('ai_engine', broker='redis://localhost:6379/0', backend='redis://localhost:6379/0')

app.conf.update(
    result_expires=3600,
)

app.autodiscover_tasks(['engine.tasks'])