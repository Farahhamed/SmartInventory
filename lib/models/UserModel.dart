import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String password;
  final String uuid; // Add UUID property

  User({
    required this.username,
    required this.password,
    required this.uuid,
  });

  // Function to convert User object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "username": username,
        "password": password,
        "uuid": uuid,
      };

  // Function to create a User object from a Firestore document
  static User fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return User(
      username: data['username'],
      password: data['password'],
      uuid: data['uuid'],
    );
  }
}
