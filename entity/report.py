from dataclasses import dataclass, field
from datetime import datetime
from .incident import Incident # Relative import for Incident

@dataclass
class Report:
    report_id: int = 0 # Default for new reports, DB will assign real ID
    incident: Incident = field(default=None) # Store the incident object directly
    # If you need to store incident_id separately in DB:
    # incident_id: int = 0 # Or provide default=None if it can be null

    reporting_officer_id: int = field(default=None) # Optional
    report_date: datetime = field(default_factory=datetime.now) # Default to current time
    report_details: str = "" # Default to empty string
    status: str = "Generated" # Default status for a new report

    # If you want a specific incident_id field in your DB table,
    # ensure your dataclass reflects it and your service maps it.
    # For simplicity, we are using the 'incident' object directly.