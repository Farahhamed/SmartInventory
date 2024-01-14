import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AddEmployeeScreen.dart';
import 'package:smartinventory/services/EmployeeService.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _OdooMethodsViewState createState() => _OdooMethodsViewState();
}

class _OdooMethodsViewState extends State<EmployeeScreen> {
  List<Map<String, dynamic>> records = [];
  final EmployeesService odooMethodsHelper = EmployeesService();
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await odooMethodsHelper.fetchData();
    setState(() {
      records = data;
    });
  }

  Future<void> addEmployee() async {
    await odooMethodsHelper.addEmployee(
      employeeNameController.text,
      jobTitleController.text,
    );
    fetchData(); // Refresh data after adding an employee
    Navigator.pop(context); // Close the Add Employee form after adding
  }

  void navigateToAddEmployeeForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(
          employeeNameController: employeeNameController,
          jobTitleController: jobTitleController,
          addEmployee: addEmployee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToAddEmployeeForm,
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
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(16.0),
              color: Colors.white, // Card background color
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      records[index]['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Job Title: ${records[index]['job_title']}',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

