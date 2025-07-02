# entity/status.py (Corrected definition)
class Status:
    def __init__(self, status_name: str):
        self.status = status_name # Or self.name = status_name, then use self.name elsewhere