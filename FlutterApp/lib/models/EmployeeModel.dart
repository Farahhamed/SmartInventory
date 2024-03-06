import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/BranchesModel.dart';

class Employee {
  final String name;
  final String position;
  final String phoneNumber;
  final Branches branch;
  final String id; // Remove final from uuid

  // Constructor with UUID generation
  Employee({
    required this.name,
    required this.position,
    required this.branch,
    required this.id,
    required this.phoneNumber
  });

  // Function to convert Employee object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "position": position,
        "branchId": branch.id,
        "phoneNumber" : phoneNumber,
        "id": id,
      };

 // Function to create an Employee object from a Firestore document
static Future<Employee> fromSnapshot(DocumentSnapshot snapshot) async {
  var data = snapshot.data() as Map<String, dynamic>;
  
  // Fetch the branch document from Firestore
  DocumentSnapshot branchSnapshot = await FirebaseFirestore.instance.collection('branches').doc(data['branchId']).get();
  
  // Create a Branches object using data from the branch document
  Branches branch = Branches.fromSnapshot(branchSnapshot);

  return Employee(
    name: data['name'],
    position: data['position'],
    phoneNumber: data['phoneNumber'],
    id: snapshot.id,
    branch: branch,
  );
}



}
