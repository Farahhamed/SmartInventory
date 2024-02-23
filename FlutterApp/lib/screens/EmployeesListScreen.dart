import 'package:flutter/material.dart';

class EmployeeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        bool isMorningShift = index % 2 == 0;
        String employeeName = 'Employee $index';
        String employeeRFID = 'RFID$index';
        int employeeNumber = 01005684752;
        int employeeAge = 25 + index;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2.0, // Decreased elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: isMorningShift
                    ? const Color.fromARGB(255, 188, 175, 62)
                    : const Color.fromARGB(255, 36, 76, 108),
                child: Icon(Icons.person),
              ),
              title: Text(
                employeeName,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Making the name bold
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RFID: $employeeRFID'), // Moved RFID to subtitle
                  Text(
                      'Phone Number: $employeeNumber'), // Moved Phone Number to subtitle
                  Text('Age: $employeeAge'), // Moved Age to subtitle
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Implement edit functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red, // Set color to red
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
