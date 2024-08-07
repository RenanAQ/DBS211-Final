-- CREATE TABLE
-- Patients 
CREATE TABLE Patients (
    PatientID NUMBER(5) PRIMARY KEY,
    FirstName VARCHAR2(25) NOT NULL,
    LastName VARCHAR2(25) NOT NULL,
    DOB DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
    ContactNumber NUMBER(11) NOT NULL,
    Email VARCHAR2(100),
    Address VARCHAR2(255),
    EmergencyContact NUMBER(11),
    InsuranceDetails VARCHAR2(255)
);

-- Doctors 
CREATE TABLE Doctors (
    DoctorID NUMBER(5) PRIMARY KEY,
    FirstName VARCHAR2(25) NOT NULL,
    LastName VARCHAR2(25) NOT NULL,
    Specialty VARCHAR2(100) NOT NULL,
    ContactNumber NUMBER(11) NOT NULL,
    Email VARCHAR2(100),
    OfficeNumber VARCHAR2(10)
);

-- Appointments 
CREATE TABLE Appointments (
    AppointmentID NUMBER(5) PRIMARY KEY,
    PatientID NUMBER(5) REFERENCES Patients(PatientID),
    DoctorID NUMBER(5) REFERENCES Doctors(DoctorID),
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIMESTAMP NOT NULL,
    ReasonForVisit VARCHAR2(255) NOT NULL,
    Status VARCHAR2(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')) NOT NULL
);

-- Doctors_Schedules 
CREATE TABLE Doctors_Schedules (
    ScheduleID NUMBER(5) PRIMARY KEY,
    DoctorID NUMBER(5) REFERENCES Doctors(DoctorID),
    DayOfWeek VARCHAR2(10) NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    Availability CHAR(1) DEFAULT 'N' CHECK (Availability IN ('Y', 'N')) NOT NULL
);

-- Billing 
CREATE TABLE Billing (
    BillingID NUMBER(5) PRIMARY KEY,
    PatientID NUMBER(5) REFERENCES Patients(PatientID),
    AppointmentID NUMBER(5) REFERENCES Appointments(AppointmentID),
    TotalAmount NUMBER(10, 2) DEFAULT 0.00 NOT NULL,
    AmountPaid NUMBER(10, 2) DEFAULT 0.00,
    PaymentStatus VARCHAR2(20) CHECK (PaymentStatus IN ('Unpaid', 'Paid', 'Refunded')) NOT NULL,
    BillingDate DATE NOT NULL
);

-- Records 
CREATE TABLE Records (
    RecordID NUMBER(5) PRIMARY KEY,
    PatientID NUMBER(5) REFERENCES Patients(PatientID),
    DoctorID NUMBER(5) REFERENCES Doctors(DoctorID),
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR2(255) NOT NULL,
    Treatment VARCHAR2(255),
    Notes VARCHAR2(4000)
);

-- INSERT SAMPLE DATA
-- Patients 
INSERT INTO Patients (PatientID, FirstName, LastName, DOB, Gender, ContactNumber, Email, Address, EmergencyContact, InsuranceDetails)
VALUES (12345, 'Bob', 'McKenzie', DATE '1972-05-16', 'M', 4164915050, 'slee588@myseneca.ca', '1750 Finch Ave E', 4164915050, 'Morecare Insurance');

-- Doctors 
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, ContactNumber, Email, OfficeNumber)
VALUES (12345, 'Alice', 'Smith', 'Cardiology', 4164915050, 'alice@clinic.com', '101');

-- Appointments 
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime, ReasonForVisit, Status)
VALUES (12345, 12345, 12345, DATE '2024-08-05', TIMESTAMP '2024-08-05 10:00:00', 'Check-up', 'Scheduled');

-- Doctors_Schedules 
INSERT INTO Doctors_Schedules (ScheduleID, DoctorID, DayOfWeek, StartTime, EndTime, Availability)
VALUES (12345, 12345, 'Monday', TO_TIMESTAMP('09:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('17:00:00', 'HH24:MI:SS'), 'Y');

-- Billing 
INSERT INTO Billing (BillingID, PatientID, AppointmentID, TotalAmount, AmountPaid, PaymentStatus, BillingDate)
VALUES (12345, 12345, 12345, 200.00, 100.00, 'Unpaid', DATE '2024-08-05');

-- Records 
INSERT INTO Records (RecordID, PatientID, DoctorID, VisitDate, Diagnosis, Treatment, Notes)
VALUES (12345, 12345, 12345, DATE '2024-08-05', 'Hypertension', 'Medication', 'Follow-up in 2 weeks');

-- SELECT TABLE
SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Appointments;
SELECT * FROM Doctors_Schedules;
SELECT * FROM Billing;
SELECT * FROM Records;