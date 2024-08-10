#include <iostream>
#include <occi.h>
#include <regex>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;

int main(void)
{
    /* OCCI Variables */
    Environment *env = nullptr;
    Connection *conn = nullptr;
    /* Used Variables */
    string user = "dbs211_242ngg07";
    string pass = "12522054";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

    try
    {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is Successful!" << endl;

        // Function to remove timezone offset from time string using regex
        auto removeTimezoneOffset = [](const string& datetime) {
            return regex_replace(datetime, regex("-\\d\\d:\\d\\d"), "");
            };

        // Statements for various views
        Statement* stmt1 = conn->createStatement("SELECT appointmenttime, PatientName, PatientPhone, DoctorName, paymentstatus FROM Pending_Appointments");
        Statement* stmt2 = conn->createStatement("SELECT appointmentid, PatientName, contactnumber, appointmentdate, RemainingBalance FROM Unpaid_Appointments");
        Statement* stmt3 = conn->createStatement("SELECT PatientName, Condition, DateDiagnosed, DoctorName, specialty, email, notes FROM Patient_Conditions");
        Statement* stmt4 = conn->createStatement("SELECT DoctorName, appointmenttime, PatientName, Condition, notes FROM Doctor_Appointment_Details");

        // Execute and print Pending Appointments
        ResultSet* rs = stmt1->executeQuery();
        cout << "------------------------ Pending Appointments ------------------------" << endl;
        cout.width(22); cout << left << "Appointment Time";
        cout.width(18); cout << "Patient Name";
        cout.width(18); cout << "Patient Phone";
        cout.width(18); cout << "Doctor Name";
        cout.width(16); cout << "Payment Status" << endl;
        cout << "-------------------  ---------------  ----------------  --------------  ---------------" << endl;
        while (rs->next()) {
            cout.width(22); cout << left << removeTimezoneOffset(rs->getString(1));
            cout.width(18); cout << rs->getString(2);
            cout.width(18); cout << rs->getString(3);
            cout.width(18); cout << rs->getString(4);
            cout.width(16); cout << rs->getString(5) << endl;
        }
        cout << endl;
        stmt1->closeResultSet(rs);

        // Execute and print Unpaid Appointments
        rs = stmt2->executeQuery();
        cout << "--------------------- Unpaid Appointments ---------------------" << endl;
        cout.width(17); cout << left << "Appointment ID";
        cout.width(17); cout << "Patient Name";
        cout.width(17); cout << "Contact Number";
        cout.width(18); cout << "Appointment Date";
        cout.width(20); cout << "Remaining Balance" << endl;
        cout << "---------------  ---------------  ---------------  ---------------  ------------------" << endl;

        while (rs->next()) {
            cout.width(17); cout << left << rs->getInt(1);
            cout.width(17); cout << rs->getString(2);
            cout.width(17); cout << rs->getString(3);
            cout.width(18); cout << rs->getString(4);
            cout.width(20); cout << rs->getDouble(5) << endl;
        }
        cout << endl;
        stmt2->closeResultSet(rs);



        // Execute and print Patient Conditions
        rs = stmt3->executeQuery();
        cout << "---------------------- Patient Conditions ----------------------" << endl;
        cout.width(20); cout << left << "Patient Name";
        cout.width(15); cout << "Condition";
        cout.width(17); cout << "Date Diagnosed";
        cout.width(20); cout << "Doctor Name";
        cout.width(15); cout << "Specialty";
        cout.width(25); cout << "Email";  
        cout.width(30); cout << "Notes"; 
        cout << endl;
        cout << "------------------  -----------    ---------------  ------------        ----------     ------                   ----------------" << endl;

        int count = 0;
        while (rs->next() && count < 50) {
            cout.width(20); cout << left << rs->getString(1);
            cout.width(15); cout << rs->getString(2);
            cout.width(17); cout << rs->getString(3);
            cout.width(20); cout << rs->getString(4);
            cout.width(15); cout << rs->getString(5);
            cout.width(25); cout << rs->getString(6);
            cout.width(30); cout << rs->getString(7);
            cout << endl;
            count++;
        }
        cout << endl;
        stmt3->closeResultSet(rs);

        // Execute and print Doctor's Appointments with Patient Details
        rs = stmt4->executeQuery();
        cout << "---------- Doctor's Appointments with Patient Details ----------" << endl;
        cout.width(20); cout << left << "Doctor Name";
        cout.width(22); cout << "Appointment Time";
        cout.width(20); cout << "Patient Name";
        cout.width(15); cout << "Condition";
        cout.width(25); cout << "Notes" << endl;
        cout << "------------------  ----------------      ------------------  ------------  -------------------------" << endl;
        while (rs->next()) {
            string appointmentTime = removeTimezoneOffset(rs->getString(2));

            cout.width(20); cout << left << rs->getString(1);
            cout.width(18); cout << appointmentTime;
            cout.width(20); cout << rs->getString(3);
            cout.width(15); cout << rs->getString(4);
            cout.width(25); cout << rs->getString(5) << endl;
        }
        cout << endl;
        stmt4->closeResultSet(rs);

        conn->terminateStatement(stmt4);
        conn->terminateStatement(stmt3);
        conn->terminateStatement(stmt2);
        conn->terminateStatement(stmt1);

        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExp)
    {
        cout << sqlExp.getErrorCode() << ": " << sqlExp.getMessage();
    }

    return 0;
}
