import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/BranchesModel.dart';
import 'package:uuid/uuid.dart';

class Employee {
  final String name;
  final String position;
  final Branches branch;
  final String id; // Remove final from uuid

  // Constructor with UUID generation
  Employee({
    required this.name,
    required this.position,
    required this.branch,
    required this.id,
  });

  // Function to convert Employee object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "position": position,
        "branchId": branch.id,
        "id": id,
      };

  // Function to create an Employee object from a Firestore document
  static Employee fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Employee(
      name: data['name'],
      position: data['position'],
      branch: data['branchId'], //get branch by id method
      id: snapshot.id
    );
  }
}
