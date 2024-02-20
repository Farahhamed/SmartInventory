import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Employee {
  final String name;
  final String position;
  final String branchId;
  String uuid; // Remove final from uuid

  // Constructor with UUID generation
  Employee({
    required this.name,
    required this.position,
    required this.branchId
  }) : uuid = Uuid().v4(); // Generate UUID during instantiation

  // Function to convert Employee object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "position": position,
        "branchId": branchId,
        "uuid": uuid,
      };

  // Function to create an Employee object from a Firestore document
  static Employee fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Employee(
      name: data['name'],
      position: data['position'],
      branchId: data['branchId']
    )..uuid =
        data['uuid']; // Set UUID when creating the object from Firestore data
  }
}
