import 'package:flutter/material.dart';

void main() {
  runApp(EmployeeListPage());
}

class EmployeeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee List Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Employee List'),
        ),
        body: EmployeeList(),
      ),
    );
  }
}

class EmployeeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Assuming you have 10 employees
      itemBuilder: (context, index) {
        // Mock data for demonstration
        bool isMorningShift =
            index % 2 == 0; // Alternating morning and night shifts
        String employeeName = 'Employee $index';
        String employeeRFID = 'RFID$index';
        int employeeNumber = 01005684752;
        int employeeAge = 25 + index;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: isMorningShift
                    ? const Color.fromARGB(255, 188, 175, 62)
                    : const Color.fromARGB(255, 36, 76, 108),
                child: Icon(Icons.person),
              ),
              title: Text(employeeName),
              subtitle: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: isMorningShift
                          ? const Color.fromARGB(255, 188, 175, 62)
                          : const Color.fromARGB(255, 36, 76, 108),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      isMorningShift ? 'Morning Shift' : 'Night Shift',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('RFID: $employeeRFID'),
                  Text('Phone Number: $employeeNumber'),
                  Text('Age: $employeeAge'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
