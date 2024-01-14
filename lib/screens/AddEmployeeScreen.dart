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
              decoration: InputDecoration(labelText: 'Employee Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: jobTitleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Job Tite'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addEmployee,
              child: Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
