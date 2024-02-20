import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeType{

  final String id;
  final String name;

  EmployeeType({
    required this.id,
    required this.name,
  });

  factory EmployeeType.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EmployeeType(
      id: doc.id,
      name: data['Name'],
    );
  }
}