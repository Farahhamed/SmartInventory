// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smartinventory/models/EmployeeModel.dart'; // Import your Employee model
import 'package:smartinventory/screens/EditEmployeeScreen.dart';
import 'package:smartinventory/services/EmployeeService.dart'; // Import your EmployeeService

class EmployeeList extends StatelessWidget {
  final EmployeeService _employeeService = EmployeeService();

  EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employee>>(
  stream: _employeeService.getEmployees(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No employees found.'),
      );
    }

        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            Employee employee = snapshot.data![index];
            bool isMorningShift = index % 2 == 0;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: isMorningShift
                        ? const Color.fromARGB(255, 188, 175, 62)
                        : const Color.fromARGB(255, 36, 76, 108),
                    child: const Icon(Icons.person),
                  ),
                  title: Text(
                    employee.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RFID: ${employee.id}'),
                      Text('Phone Number: ${employee.phoneNumber}'),
                      Text('Branch: ${employee.branch.name}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editEmployee(context, employee);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _deleteEmployee(context, employee.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editEmployee(BuildContext context, Employee employee) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EmployeeEditPage(employee: employee),
    ),
  );
}

  void _deleteEmployee(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Call delete employee function from service
              await _employeeService.deleteEmployee(employeeId);
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
