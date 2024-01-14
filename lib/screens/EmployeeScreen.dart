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
    fetchData(); // Refresh data after adding a product
    Navigator.pop(context); // Close the Add Product form after adding
  }

  void navigateToAddProductForm() {
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
        title: Text('Flutter + Flask API'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToAddProductForm,
              child: Text('Add New Product'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(records[index]['name']),
                  subtitle: Text('List Price: ${records[index]['list_price']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
