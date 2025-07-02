from datetime import date

class Victim:
    def __init__(self, victim_id: int, first_name: str, last_name: str,
                 date_of_birth: date, gender: str, contact_information: str):
        self.victim_id = victim_id
        self.first_name = first_name
        self.last_name = last_name
        self.date_of_birth = date_of_birth
        self.gender = gender
        self.contact_information = contact_information