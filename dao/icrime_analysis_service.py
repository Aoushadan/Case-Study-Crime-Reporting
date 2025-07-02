from abc import ABC, abstractmethod
from typing import List
from entity.incident import Incident
from entity.status import Status
from entity.case import Case
from entity.report import Report
from datetime import datetime

class CrimeAnalysisService(ABC):

    @abstractmethod
    def create_incident(self, incident: Incident) -> bool: pass

    @abstractmethod
    def update_incident_status(self, status: Status, incident_id: int) -> bool: pass

    @abstractmethod
    def get_incidents_in_date_range(self, start_date: datetime, end_date: datetime) -> List[Incident]: pass

    @abstractmethod
    def search_incidents(self, incident_type: str) -> List[Incident]: pass

    @abstractmethod
    def generate_incident_report(self, incident: Incident) -> Report: pass

    @abstractmethod
    def create_case(self, description: str, incidents: List[Incident]) -> Case: pass

    @abstractmethod
    def get_case_details(self, case_id: int) -> Case: pass

    @abstractmethod
    def update_case_details(self, case: Case) -> bool: pass

    @abstractmethod
    def get_all_cases(self) -> List[Case]: pass
