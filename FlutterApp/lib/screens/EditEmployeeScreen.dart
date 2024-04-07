import 'package:flutter/material.dart';
import 'package:smartinventory/models/EmployeeModel.dart';
import 'package:smartinventory/services/EmployeeService.dart'; 

class EmployeeEditPage extends StatefulWidget {
  final Employee employee;

  const EmployeeEditPage({super.key, required this.employee});

  @override
  _EmployeeEditPageState createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _positionController = TextEditingController(text: widget.employee.position);
    _phoneNumberController = TextEditingController(text: widget.employee.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
  // Update employee data and save changes to Firestore
  Employee updatedEmployee = Employee(
    name: _nameController.text,
    position: _positionController.text,
    phoneNumber: _phoneNumberController.text,
    branch: widget.employee.branch,
    id: widget.employee.id,
  );
  EmployeeService().editEmployee(updatedEmployee);
  
  // Navigate back to the previous screen
  Navigator.of(context).pop();
}
}
