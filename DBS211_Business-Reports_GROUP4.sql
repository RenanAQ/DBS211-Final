--***   BUSINESS REPORT VIEWS   ***

-- Patients' Appointments

--      This view combines the information referring to the appointments while making
--      the data easier to read by incorporating the names of the patients and doctors
--      and sorting the data chronologically.

CREATE VIEW Patient_Appointments
AS SELECT 
    a.appointmenttime,
    (p.firstname || ' ' || p.lastname) AS PatientName,
    p.contactnumber AS PatientPhone,
    (d.firstname || ' ' || d.lastname) AS DoctorName,
    b.paymentstatus
FROM patients p
JOIN appointments a
    ON p.patientid = a.patientid
JOIN doctors d
    ON a.doctorid = d.doctorid
JOIN billing b
    ON a.appointmentid = b.appointmentid
ORDER BY a.appointmentdate;

SELECT * FROM Patient_Appointments;

-- Unpaid Appointments

--      This view displays all appointments that haven't been fully paid for, and
--      shows the remaining balance for it, while also showing the contact information
--      of the patient for easy access to follow up with them.

CREATE VIEW Unpaid_Appointments
AS SELECT
    a.appointmentid,
    (p.firstname || ' ' || p.lastname) AS PatientName,
    p.contactnumber,
    a.appointmentdate,
    (b.totalamount - b.amountpaid) AS RemainingBalance
FROM appointments a
JOIN billing b
    ON a.appointmentid = b.appointmentid
JOIN patients p
    ON a.patientid = p.patientid
WHERE b.paymentstatus='Unpaid'
ORDER BY b.paymentstatus;

SELECT * FROM Unpaid_Appointments;

-- Patients Condition Records

--      This view focuses on the patient's condition and can be used for reference
--      while assessing the patient's health, as well as to send promotional
--      communications for treatments regarding their ailments.

CREATE VIEW Patient_Conditions
AS SELECT
    (p.firstname || ' ' || p.lastname) AS PatientName,
    r.diagnosis AS Condition,
    r.visitdate AS DateDiagnosed,
    (d.firstname || ' ' || d.lastname) AS DoctorName,
    d.specialty,
    p.email,
    r.notes
FROM records r
JOIN patients p
    ON r.patientid = r.patientid
JOIN doctors d
    ON r.doctorid = d.doctorid
ORDER BY PatientName;

SELECT * FROM Patient_Conditions;

-- Doctor's Appointments with Patient Details

--      This view can help the doctor to have a better reference of the
--      patient's conditions before the next scheduled appointment, as
--      well as to request certain prior medical examinations for possible
--      treatment recommendations.

CREATE VIEW Doctor_Appointment_Details
AS SELECT
    (d.firstname || ' ' || d.lastname) AS DoctorName,
    a.appointmenttime,
    (p.firstname || ' ' || p.lastname) AS PatientName,
    r.diagnosis AS Condition,
    r.notes
FROM doctors d
JOIN appointments a
    ON d.doctorid = a.doctorid
JOIN patients p
    ON p.patientid = a.patientid
JOIN records r
    ON r.patientid = a.patientid
ORDER BY DoctorName;

SELECT * FROM Doctor_Appointment_Details;