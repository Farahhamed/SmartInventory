import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String uid;
  final String phoneNumber;
  final String userType;

  UserModel({
    required this.username,
    required this.email,
    required this.uid,
    required this.phoneNumber,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
        "phoneNumber": phoneNumber,
        "userType": userType,
      };


  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      username: data['username'],
      email: data['email'],
      uid: data['uid'],
      phoneNumber: data['phoneNumber'],
      userType: data['userType'],
    );
  }
}
