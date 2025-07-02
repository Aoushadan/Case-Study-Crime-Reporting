from dataclasses import dataclass
from datetime import datetime

@dataclass
class Incident:
    incident_id: int
    incident_type: str
    incident_date: datetime
    location: str
    description: str
    status: str
    victim_id: int = None
    suspect_id: int = None
    agency_id: int = None

