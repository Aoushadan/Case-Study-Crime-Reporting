import unittest
from datetime import datetime
from entity.incident import Incident
from dao.crime_analysis_service_impl import CrimeAnalysisServiceImpl

class TestCrimeAnalysisService(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        # Initialize service once for all tests
        cls.service = CrimeAnalysisServiceImpl()

    def test_create_incident_success(self):
        # Create an incident object with test data
        incident = Incident(
            incident_id=1,
            incident_type="Test Robbery",
            incident_date=datetime.now(),
            location="POINT(-89.6500 39.7983)",  # or your geometry object
            description="Test description",
            status="Open",
            victim_id=1,
            suspect_id=None,
            agency_id=1
        )

        result = self.service.create_incident(incident)
        self.assertTrue(result, "Incident creation should return True")

    def test_update_incident_status_success(self):

        incident_id = 1
        new_status = "Closed"

        result = self.service.update_incident_status(new_status, incident_id)
        self.assertTrue(result, "Updating incident status should return True")

    def test_update_incident_status_invalid_incident(self):
        # Update a non-existent incident should raise exception or return False
        incident_id = 999999  # Assuming this ID doesn't exist
        new_status = "Closed"

        with self.assertRaises(Exception):  # Or your custom exception like IncidentNumberNotFoundException
            self.service.update_incident_status(new_status, incident_id)


if __name__ == "__main__":
    unittest.main()

