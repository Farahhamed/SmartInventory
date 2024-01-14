import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatelessWidget {
  final TextEditingController employeeNameController;
  final TextEditingController jobTitleController;
  final VoidCallback addEmployee;

  AddEmployeeScreen({
    required this.employeeNameController,
    required this.jobTitleController,
    required this.addEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: employeeNameController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Employee Name',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: jobTitleController,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Job Title',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addEmployee,
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo, // Button color
                onPrimary: Colors.white, // Text color on button
                padding: EdgeInsets.all(16.0),
              ),
              child: Text(
                'Add New Employee',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
