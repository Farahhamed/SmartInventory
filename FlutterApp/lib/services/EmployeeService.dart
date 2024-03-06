import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/EmployeeModel.dart';


class EmployeeService {
  final CollectionReference _employeesCollection =
      FirebaseFirestore.instance.collection('employees');

  // Function to add an employee
  Future<void> addEmployee(Employee employee) async {
    await _employeesCollection.add(employee.toMap());
  }

  // Function to edit an employee
  Future<void> editEmployee(Employee employee) async {
    await _employeesCollection.doc(employee.id).update(employee.toMap());
  }

  // Function to delete an employee
  Future<void> deleteEmployee(String employeeId) async {
    await _employeesCollection.doc(employeeId).delete();
  }

  // Function to get all employees
Stream<List<Employee>> getEmployees() {
  return _employeesCollection.snapshots().asyncMap((snapshot) async {
    List<Employee> employees = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      Employee employee = await Employee.fromSnapshot(doc); // Await each call
      employees.add(employee);
    }
    return employees;
  });
}


}