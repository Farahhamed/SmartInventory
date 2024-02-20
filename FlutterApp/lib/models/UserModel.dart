import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String employeeId;
  final String userName;
  final String password;

  User({
   required this.id,
    required this.employeeId,
    required this.userName,
    required this.password,
  });

  // Function to convert User object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "username": userName,
        "password": password,
        "employeeId": employeeId,
        "id": id,
      };

  // Function to create a User object from a Firestore document
  static User fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return User(
      id: snapshot.id,
      employeeId: data['EmployeeId'],
      userName: data['UserName'],
      password: data['Password'],
    );
  }
}
