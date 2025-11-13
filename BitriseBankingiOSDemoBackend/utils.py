import uuid
from datetime import datetime

def generate_uuid() -> str:
    return str(uuid.uuid4())

def generate_account_number() -> str:
    return str(uuid.uuid4()).split('-')[0]  # shorter for demo

def current_timestamp() -> str:
    return datetime.utcnow().isoformat()

def default_balance() -> float:
    return 1000.0
