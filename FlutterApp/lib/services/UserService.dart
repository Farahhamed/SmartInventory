import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/EmployeeModel.dart';
import 'package:smartinventory/models/EmployeeTypeModel.dart';
import 'package:smartinventory/models/UserModel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Employee>> getEmployees() async {
    QuerySnapshot snapshot = await _firestore.collection('employees').get();
    return snapshot.docs.map((doc) => Employee.fromSnapshot(doc)).toList();
  }

  Future<List<EmployeeType>> getEmployeeTypes() async {
    QuerySnapshot snapshot = await _firestore.collection('employeeTypes').get();
    return snapshot.docs.map((doc) => EmployeeType.fromFirestore(doc)).toList();
  }

  Future<List<UserModel>> getUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }
}
