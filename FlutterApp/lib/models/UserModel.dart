import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String uid; // Use "uid" instead of "uuid"

  UserModel({
    required this.username,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
      };

  // Function to create a User object from a Firestore document
  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      username: data['username'],
      email: data['email'],
      uid: data['uid'],
    );
  }
}
