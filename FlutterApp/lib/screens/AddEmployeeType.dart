import 'dart:convert';
import 'package:smartinventory/services/EmployeeTypeService.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/EmployeeTypeModel.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';

class AddEmployeeType extends StatefulWidget {
  const AddEmployeeType({Key? key}) : super(key: key);

  @override
  State<AddEmployeeType> createState() => _AddEmployeeTypeState();
}

class _AddEmployeeTypeState extends State<AddEmployeeType> {
  String _employeeTypeName = '';
  TextEditingController _employeeTypeController = TextEditingController();
   final EmployeeTypeService _EmployeeTypeService = EmployeeTypeService();

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Add new Employee Type',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      labelText: 'Employee Type',
                      onChanged: (value) {
                        setState(() {
                          _employeeTypeName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addEmployeeType,
                          child: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(112, 66, 100, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: _employeeTypeController  ,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter $labelText',
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFBB8493),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFBB8493),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  void _addEmployeeType() async {
  
  if (_employeeTypeName.isNotEmpty) {
     bool added = await _EmployeeTypeService.addEmployeeType( _employeeTypeName);
    try {
      // Show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee type added successfully'),
        ),
      );
      _employeeTypeController.clear();
    } catch (error) {
      // Handle errors
      print('Error adding employee type: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add employee type'),
        ),
      );
    }
  } else {
    // Show an error message if the employee type name is empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter an employee type name'),
      ),
    );
  }
}
}
