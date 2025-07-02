class IncidentNumberNotFoundException(Exception):
    def __init__(self, message="Incident number not found"):
        super().__init__(message)
