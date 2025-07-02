
--------------------------------------------------------CREATING---------------------------------------------------------------------


CREATE TABLE Victims (
    VictimID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    ContactInformation TEXT NULL
);

CREATE TABLE Suspects (
    SuspectID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    ContactInformation TEXT NULL
);

CREATE TABLE LawEnforcementAgencies (
    AgencyID INT IDENTITY(1,1) PRIMARY KEY,
    AgencyName VARCHAR(100) NOT NULL,
    Jurisdiction VARCHAR(100) NOT NULL,
    ContactInformation TEXT NULL
);

CREATE TABLE Officers (
    OfficerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    BadgeNumber VARCHAR(20) NOT NULL,
    Rank VARCHAR(50) NOT NULL,
    ContactInformation TEXT NULL,
    AgencyID INT NOT NULL,
    FOREIGN KEY (AgencyID) REFERENCES LawEnforcementAgencies(AgencyID)
);

CREATE TABLE Incidents (
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentType VARCHAR(50) NOT NULL,
    IncidentDate DATETIME NOT NULL,
    Location GEOGRAPHY NOT NULL,
    Description TEXT NULL,
    Status VARCHAR(20) NOT NULL,
    VictimID INT NOT NULL,
    SuspectID INT NULL,
    AgencyID INT NOT NULL,
    FOREIGN KEY (VictimID) REFERENCES Victims(VictimID),
    FOREIGN KEY (SuspectID) REFERENCES Suspects(SuspectID),
);

CREATE TABLE Evidence (
    EvidenceID INT IDENTITY(1,1) PRIMARY KEY,
    Description TEXT NOT NULL,
    LocationFound GEOGRAPHY NOT NULL,
    IncidentID INT NOT NULL,
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

CREATE TABLE Reports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentID INT NOT NULL,
    ReportingOfficer INT NOT NULL,
    ReportDate DATETIME NOT NULL,
    ReportDetails TEXT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID),
    FOREIGN KEY (ReportingOfficer) REFERENCES Officers(OfficerID)
);

-- Create the Cases table
CREATE TABLE Cases (
    CaseID INT PRIMARY KEY IDENTITY(1,1),
    Description NVARCHAR(MAX) NOT NULL,
    -- Add any other relevant columns, e.g., CreatedDate, Status, LeadOfficerID
    CreatedDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Open'
);

-- Create the CaseIncidents table (for many-to-many relationship)
CREATE TABLE CaseIncidents (
    CaseIncidentID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    IncidentID INT NOT NULL,
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

--------------------------------------------------------INSERTING----------------------------------------------------------------------


-- Insert 10 records into the Victims table
INSERT INTO Victims (FirstName, LastName, DateOfBirth, Gender, ContactInformation)
VALUES
    ('John', 'Doe', '1985-06-15', 'Male', '1234 Elm St, Springfield, IL'),
    ('Emily', 'Clark', '1992-11-22', 'Female', '5678 Maple Ave, Springfield, IL'),
    ('Michael', 'Johnson', '1988-03-15', 'Male', '9101 Pine St, Springfield, IL'),
    ('Sarah', 'Davis', '1995-07-30', 'Female', '1122 Birch Rd, Springfield, IL'),
    ('David', 'Martinez', '1983-01-05', 'Male', '3344 Cedar Blvd, Springfield, IL'),
    ('Ava', 'Miller', '1996-02-20', 'Female', '4455 Oak Dr, Springfield, IL'),
    ('Ethan', 'Garcia', '1991-08-14', 'Male', '6677 Pine St, Springfield, IL'),
    ('Isabella', 'Rodriguez', '1989-11-30', 'Female', '8899 Maple Ave, Springfield, IL'),
    ('Liam', 'Martinez', '1990-05-10', 'Male', '1011 Oak Ln, Springfield, IL'),
    ('Sophia', 'Taylor', '1994-04-18', 'Female', '2233 Maple Ct, Springfield, IL');

-- Insert 10 records into the Suspects table
INSERT INTO Suspects (FirstName, LastName, DateOfBirth, Gender, ContactInformation)
VALUES
    ('Jane', 'Smith', '1990-04-20', 'Female', '5678 Oak St, Springfield, IL'),
    ('James', 'Brown', '1990-05-10', 'Male', '5567 Oak Dr, Springfield, IL'),
    ('Olivia', 'Wilson', '1993-09-25', 'Female', '7789 Elm St, Springfield, IL'),
    ('Liam', 'Moore', '1987-12-12', 'Male', '9901 Pine Ln, Springfield, IL'),
    ('Sophia', 'Taylor', '1994-04-18', 'Female', '2233 Maple Ct, Springfield, IL'),
    ('Lucas', 'Anderson', '1992-07-22', 'Male', '4455 Oak Dr, Springfield, IL'),
    ('Mia', 'Thomas', '1991-11-30', 'Female', '6677 Pine St, Springfield, IL'),
    ('Benjamin', 'Jackson', '1988-02-14', 'Male', '8899 Maple Ave, Springfield, IL'),
    ('Charlotte', 'White', '1990-05-10', 'Female', '1011 Oak Ln, Springfield, IL'),
    ('Amelia', 'Harris', '1993-08-09', 'Female', '2233 Maple Ct, Springfield, IL');

-- Insert 10 records into the LawEnforcementAgencies table
INSERT INTO LawEnforcementAgencies (AgencyName, Jurisdiction, ContactInformation)
VALUES
    ('Springfield Police Department', 'Springfield', '123 Police Plaza, Springfield, IL'),
    ('Springfield County Sheriff', 'Springfield County', '5678 Sheriff Rd, Springfield, IL'),
    ('Illinois State Police', 'Statewide', '1234 State Police Blvd, Springfield, IL'),
    ('Chicago Police Department', 'Chicago', '5678 Police Ave, Chicago, IL'),
    ('Cook County Sheriff', 'Cook County', '9101 Sheriff Ln, Chicago, IL'),
    ('Peoria Police Department', 'Peoria', '1122 Police St, Peoria, IL'),
    ('Champaign Police Department', 'Champaign', '3344 Police Blvd, Champaign, IL'),
    ('Rockford Police Department', 'Rockford', '5567 Police Dr, Rockford, IL'),
    ('Naperville Police Department', 'Naperville', '7789 Police Ct, Naperville, IL'),
    ('Aurora Police Department', 'Aurora', '9901 Police Ln, Aurora, IL');

-- Insert 10 records into the Officers table
INSERT INTO Officers (FirstName, LastName, BadgeNumber, Rank, ContactInformation, AgencyID)
VALUES
    ('Alice', 'Johnson', 'A123', 'Sergeant', '1234 Police Ave, Springfield, IL', 1),
    ('John', 'Smith', 'B456', 'Lieutenant', '5678 Police Ave, Springfield, IL', 2),
    ('Linda', 'Williams', 'C789', 'Sergeant', '9101 Police St, Springfield, IL', 3),
    ('Michael', 'Davis', 'D012', 'Officer', '1122 Police Rd, Springfield, IL', 4),
    ('Emily', 'Martinez', 'E345', 'Officer', '3344 Police Blvd, Springfield, IL', 5),
    ('David', 'Garcia', 'F678', 'Lieutenant', '5567 Police Dr, Springfield, IL', 6),
    ('Sophia', 'Rodriguez', 'G901', 'Sergeant', '7789 Police Ct, Springfield, IL', 7),
    ('James', 'Hernandez', 'H234', 'Officer', '9901 Police Ln, Springfield, IL', 8),
    ('Olivia', 'Lopez', 'I567', 'Officer', '1122 Police St, Springfield, IL', 9),
    ('Lucas', 'Gonzalez', 'J890', 'Lieutenant', '3344 Police Blvd, Springfield, IL', 10);

-- Insert 10 records into the Incidents table
INSERT INTO Incidents (IncidentType, IncidentDate, Location, Description, Status, VictimID, SuspectID, AgencyID)
VALUES
    ('Robbery', '2025-06-10 14:30:00', 'POINT(-89.6500 39.7983)', 'Robbery at Springfield Bank', 'Open', 1, 1, 1),
    ('Assault', '2025-06-12 18:45:00', 'POINT(-89.6501 39.7984)', 'Assault at Springfield Park', 'Under Investigation', 2, 2, 2),
    ('Burglary', '2025-06-13 20:30:00', 'POINT(-89.6502 39.7985)', 'Burglary at Springfield Mall', 'Open', 3, 3, 3),
    ('Theft', '2025-06-14 10:15:00', 'POINT(-89.6503 39.7986)', 'Theft at Springfield Library', 'Closed', 4, 4, 4),
    ('Vandalism', '2025-06-15 16:00:00', 'POINT(-89.6504 39.7987)', 'Vandalism at Springfield School', 'Open', 5, 5, 5),
    ('Fraud', '2025-06-16 12:30:00', 'POINT(-89.6505 39.7988)', 'Fraud at Springfield Post Office', 'Under Investigation', 6, 6, 6),
    ('Drug Offense', '2025-06-17 14:45:00', 'POINT(-89.6506 39.7989)', 'Drug Offense at Springfield Park', 'Open', 7, 7, 7),
    ('Homicide', '2025-06-18 09:00:00', 'POINT(-89.6507 39.7990)', 'Homicide at Springfield Apartment', 'Closed', 8, 8, 8),
    ('Kidnapping', '2025-06-19 11:15:00', 'POINT(-89.6508 39.7991)', 'Kidnapping at Springfield Mall', 'Under Investigation', 9, 9, 9),
    ('Arson', '2025-06-20 13:30:00', 'POINT(-89.6509 39.7992)', 'Arson at Springfield Warehouse', 'Open', 10, 10, 10);

-- Insert 10 records into the Evidence table
INSERT INTO Evidence (Description, LocationFound, IncidentID)
VALUES
    ('Security camera footage', 'POINT(-89.6500 39.7983)', 1),
    ('Witness testimony', 'POINT(-89.6501 39.7984)', 2),
    ('Security camera footage', 'POINT(-89.6502 39.7985)', 3),
    ('Fingerprint analysis', 'POINT(-89.6503 39.7986)', 4),
    ('DNA sample', 'POINT(-89.6504 39.7987)', 5),
    ('Email correspondence', 'POINT(-89.6505 39.7988)', 6),
    ('Drug paraphernalia', 'POINT(-89.6506 39.7989)', 7),
    ('Autopsy report', 'POINT(-89.6507 39.7990)', 8),
    ('Security camera footage', 'POINT(-89.6508 39.7991)', 9),
    ('Fire department report', 'POINT(-89.6509 39.7992)', 10);



-- Insert 10 records into the Reports table
INSERT INTO Reports (IncidentID, ReportingOfficer, ReportDate, ReportDetails, Status)
VALUES
    (1, 1, '2025-06-10 15:00:00', 'Initial report filed by Officer Alice Johnson regarding the robbery at Springfield Bank.', 'Finalized'),
    (2, 2, '2025-06-12 19:00:00', 'Initial report filed by Officer John Smith regarding the assault at Springfield Park.', 'Draft'),
    (3, 3, '2025-06-13 21:00:00', 'Initial report filed by Officer Linda Williams regarding the burglary at Springfield Mall.', 'Finalized'),
    (4, 4, '2025-06-14 11:00:00', 'Initial report filed by Officer Michael Davis regarding the theft at Springfield Library.', 'Finalized'),
    (5, 5, '2025-06-15 17:00:00', 'Initial report filed by Officer Emily Martinez regarding the vandalism at Springfield School.', 'Draft'),
    (6, 6, '2025-06-16 13:00:00', 'Initial report filed by Officer David Garcia regarding the fraud at Springfield Post Office.', 'Under Investigation'),
    (7, 7, '2025-06-17 15:00:00', 'Initial report filed by Officer Sophia Rodriguez regarding the drug offense at Springfield Park.', 'Finalized'),
    (8, 8, '2025-06-18 10:00:00', 'Initial report filed by Officer James Hernandez regarding the homicide at Springfield Apartment.', 'Finalized'),
    (9, 9, '2025-06-19 12:00:00', 'Initial report filed by Officer Olivia Lopez regarding the kidnapping at Springfield Mall.', 'Under Investigation'),
    (10, 10, '2025-06-20 14:00:00', 'Initial report filed by Officer Lucas Gonzalez regarding the arson at Springfield Warehouse.', 'Draft');

INSERT INTO CaseIncidents (CaseID,IncidentID)
VALUES
(1, 2), -- Case 1 (Major Theft) linked to Incident 2 (Theft)
(2, 1), -- Case 2 (Burglary Spree) linked to Incident 1 (Burglary)
(3, 3), -- Case 3 (Assault) linked to Incident 3 (Assault)
(1, 4); -- Case 1 (Major Theft) also linked to Incident 4 (Robbery)

INSERT INTO Cases (Description, CreatedDate, Status)
VALUES
('Major Theft Investigation - Metro Area', GETDATE(), 'Open'),
('Burglary Spree - East District', GETDATE(), 'Under Investigation'),
('Assault and Battery - Public Park', GETDATE(), 'Closed');



 SELECT * FROM Incidents;
 SELECT * FROM Victims;
 SELECT * FROM Suspects;
 SELECT * FROM LawEnforcementAgencies;
 SELECT * FROM Officers;
 SELECT * FROM Evidence;
 SELECT * FROM Reports;
 SELECT * FROM Cases;
 SELECT * FROM CaseIncidents;

