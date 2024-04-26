 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/models/EmployeeTypeModel.dart';
import 'package:uuid/uuid.dart';

class EmployeeTypeService{
Future<bool> addEmployeeType(String type) async {
    final CollectionReference _EmployeeTypeCollection =
    FirebaseFirestore.instance.collection('employee_type');
    var uuid= Uuid().v4();

      // Create a new EmployeeType instance
      EmployeeType newEmployeeType = EmployeeType(
        id: uuid,
        name:type ,
      );
   await  _EmployeeTypeCollection.doc(uuid).set(newEmployeeType.toJson());

  return true;
  }
}