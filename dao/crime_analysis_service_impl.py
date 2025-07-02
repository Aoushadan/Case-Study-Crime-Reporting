import pyodbc
from typing import List
from datetime import datetime
from dao.icrime_analysis_service import CrimeAnalysisService
from entity.incident import Incident
from entity.status import Status
from entity.case import Case
from entity.report import Report
from util.db_conn_util import DBConnUtil
from exception.incident_number_not_found import IncidentNumberNotFoundException

class CrimeAnalysisServiceImpl(CrimeAnalysisService):
    def __init__(self):
        self.conn = DBConnUtil.get_connection()

    def create_incident(self, incident: Incident) -> bool:
        cursor = self.conn.cursor()
        try:
            # 1. Specify ALL columns you intend to insert into, EXCEPT IncidentID (as it's IDENTITY)
            # 2. Ensure the number of '?' matches the number of columns.
            # 3. Ensure the order of parameters in the tuple matches the column order.
            sql = """
            INSERT INTO Incidents
            (IncidentType, IncidentDate, Location, Description, Status, VictimID, SuspectID, AgencyID)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """

            # Pass the values from the Incident object.
            # - incident.status should be a string (from main.py fix)
            # - incident.suspect_id can be None (which translates to NULL in DB)
            cursor.execute(
                sql,
                (incident.incident_type,
                 incident.incident_date,
                 incident.location,
                 incident.description,
                 incident.status, # This should be the string (e.g., "Open")
                 incident.victim_id,
                 incident.suspect_id, # This can be None, handled by SuspectID INT NULL
                 incident.agency_id)
            )
            self.conn.commit()
            return True
        except pyodbc.Error as e:
            print(f"Error creating incident: {e}")
            return False

    def update_incident_status(self, new_status, incident_id):
        connection = None
        cursor = None
        try:
            connection = self.connection_pool.get_connection() if hasattr(self, 'connection_pool') else self.conn
            cursor = connection.cursor()
            cursor.execute("SELECT Status FROM Incidents WHERE IncidentID = ?", (incident_id,))
            if cursor.fetchone() is None:
                raise IncidentNumberNotFoundException(f"Incident ID {incident_id} not found.")
            cursor.execute("UPDATE Incidents SET Status = ? WHERE IncidentID = ?", (new_status, incident_id))
            connection.commit()
            return True

        except pyodbc.Error as e:
            print(f"Database error: {e}")
            return False

        finally:
            if cursor:
                cursor.close()
            # Only close if we opened a new connection; do not close shared `self.conn`
            if connection and hasattr(self, 'connection_pool'):
                self.connection_pool.release(connection)
            # If using a single connection `self.conn`, do NOT close it here

    def get_incidents_in_date_range(self, start_date: datetime, end_date: datetime) -> List[Incident]:
        cursor = self.conn.cursor()
        cursor.execute(
            """
            SELECT IncidentID, IncidentType, IncidentDate, Location.ToString() AS Location,
                   Description, Status, VictimID, SuspectID, AgencyID
            FROM Incidents
            WHERE IncidentDate BETWEEN ? AND ?
            """,
            (start_date, end_date)
        )
        rows = cursor.fetchall()
        return [self._map_row_to_incident(row) for row in rows]

    def search_incidents(self, incident_type: str) -> List[Incident]:
        cursor = self.conn.cursor()
        cursor.execute(
            """
            SELECT IncidentID, IncidentType, IncidentDate, Location.ToString() AS Location,
                   Description, Status, VictimID, SuspectID, AgencyID
            FROM Incidents
            WHERE IncidentType = ?
            """,
            (incident_type,)
        )
        rows = cursor.fetchall()
        return [self._map_row_to_incident(row) for row in rows]

    def generate_incident_report(self, incident: Incident) -> Report:

        report = Report()
        report.incident = incident
        report.content = f"Report generated for Incident ID: {incident.incident_id}"
        # For a full implementation, you'd also fetch ReportDate, ReportingOfficer etc.
        report.report_date = datetime.now() # Adding a placeholder report_date
        return report

    def create_case(self, description: str, incidents: List[Incident]) -> Case:
        cursor = self.conn.cursor()
        try:
            # Step 1: Insert and get the CaseID immediately
            cursor.execute(
                "INSERT INTO Cases (Description) OUTPUT INSERTED.CaseID VALUES (?)",
                (description,)
            )
            case_id = cursor.fetchone()[0]


            if incidents:
                for incident in incidents:
                    cursor.execute(
                        "INSERT INTO CaseIncidents (CaseID, IncidentID) VALUES (?, ?)",
                        (case_id, incident.incident_id)
                    )

            self.conn.commit()


            return self.get_case_details(case_id)

        except pyodbc.Error as e:
            print(f"Error creating case: {e}")
            self.conn.rollback()
            return None

    def get_case_details(self, case_id: int) -> Case:
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Cases WHERE CaseID = ?", (case_id,))
        row = cursor.fetchone()
        if not row:
            return None
        case = Case()
        case.case_id = row.CaseID
        case.description = row.Description

        cursor.execute(
            """
            SELECT i.IncidentID, i.IncidentType, i.IncidentDate, i.Location.ToString() AS Location,
                   i.Description, i.Status, i.VictimID, i.SuspectID, i.AgencyID
            FROM Incidents i
            INNER JOIN CaseIncidents ci ON i.IncidentID = ci.IncidentID
            WHERE ci.CaseID = ?
            """,
            (case_id,)
        )
        incidents_rows = cursor.fetchall()
        case.incidents = [self._map_row_to_incident(r) for r in incidents_rows]

        return case

    def update_case_details(self, case: Case) -> bool:
        cursor = self.conn.cursor()
        try:
            cursor.execute(
                "UPDATE Cases SET Description = ? WHERE CaseID = ?",
                (case.description, case.case_id)
            )
            # For simplicity, not updating linked incidents here.
            self.conn.commit()
            return True
        except pyodbc.Error as e:
            print(f"Error updating case: {e}")
            self.conn.rollback()
            return False

    def get_all_cases(self) -> List[Case]:
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Cases")
        rows = cursor.fetchall()
        cases = []
        for row in rows:
            case = Case()
            case.case_id = row.CaseID
            case.description = row.Description
            # Fetch incidents for each case
            cursor.execute(
                """
                SELECT i.IncidentID, i.IncidentType, i.IncidentDate, i.Location.ToString() AS Location,
                       i.Description, i.Status, i.VictimID, i.SuspectID, i.AgencyID
                FROM Incidents i
                INNER JOIN CaseIncidents ci ON i.IncidentID = ci.IncidentID
                WHERE ci.CaseID = ?
                """,
                (case.case_id,)
            )
            incidents_rows = cursor.fetchall()
            case.incidents = [self._map_row_to_incident(r) for r in incidents_rows]
            cases.append(case)
        return cases

    # Placeholder for _map_row_to_incident method
    # You need to implement this based on your Incident class structure and database columns
    def _map_row_to_incident(self, row) -> Incident:
        # Example implementation - adjust according to your Incident class's __init__ and DB columns
        # Assuming your Incident class can take an ID for existing incidents
        incident = Incident(
            incident_id=row.IncidentID, # Retrieve ID from DB for existing incidents
            incident_type=row.IncidentType,
            incident_date=row.IncidentDate,
            location=str(row.Location), # Convert to string here
            description=row.Description,
            status=row.Status, # Assuming Status is stored as a string in DB
            victim_id=row.VictimID,
            suspect_id=row.SuspectID,
            agency_id=row.AgencyID
        )
        return incident