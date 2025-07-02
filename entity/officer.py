class Officer:
    def __init__(self, officer_id: int, first_name: str, last_name: str,
                 badge_number: str, rank: str, contact_info: str, agency_id: int):
        self.officer_id = officer_id
        self.first_name = first_name
        self.last_name = last_name
        self.badge_number = badge_number
        self.rank = rank
        self.contact_info = contact_info
        self.agency_id = agency_id