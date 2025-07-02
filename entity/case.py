from typing import List
from .incident import Incident

class Case:
    def __init__(self, case_id: int = 0, description: str = "", incidents: List[Incident] = None):
        self.case_id = case_id
        self.description = description
        self.incidents = incidents if incidents is not None else []