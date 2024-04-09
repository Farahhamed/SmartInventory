import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatelessWidget {
  final TextEditingController employeeNameController;
  final TextEditingController jobTitleController;
  final VoidCallback addEmployee;

  const AddEmployeeScreen({super.key, 
    required this.employeeNameController,
    required this.jobTitleController,
    required this.addEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: employeeNameController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'Employee Name',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jobTitleController,
              style: const TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addEmployee,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.indigo, // Text color on button
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
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
