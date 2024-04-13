import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String uid;
  final String phoneNumber;
  final String userType;
  final String Age;
  final String TagUid ;

  UserModel({
    required this.username,
    required this.email,
    required this.uid,
    required this.phoneNumber,
    required this.userType,
    required this.Age,
    required this.TagUid,
  });

  Map<String, dynamic> toJson() => {
        "name": username,
        "email": email,
        "UID": uid,
        "phone number": phoneNumber,
        "employeeType": userType,
        "age" : Age,
        "Tag" : TagUid,
      };

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      username : data['name'],
      email: data['email'],
      uid: data['UID'],
      phoneNumber: data['phone number'],
      userType : data['employeeType'],
      Age: data['age'],
      TagUid :data['Tag']
    );
  }
}
