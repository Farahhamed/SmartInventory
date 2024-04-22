import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/BranchesModel.dart';

class UserModel {
  final String username;
  final String email;
  final String uid;
  final String phoneNumber;
  final String userType;
  final String Age;
  final String TagUid;
  final String address;
  final DateTime DateOfEmployment;
  final String pic;
  final String branchId;
  final bool IsDeleted;

  UserModel({
    required this.username,
    required this.email,
    required this.uid,
    required this.phoneNumber,
    required this.userType,
    required this.Age,
    required this.TagUid,
    required this.address,
    required this.DateOfEmployment,
    required this.pic,
    required this.branchId,
    required this.IsDeleted
  });

  Map<String, dynamic> toJson() => {
        "name": username,
        "email": email,
        "UID": uid,
        "phone number": phoneNumber,
        "employeeType": userType,
        "age": Age,
        "Tag": TagUid,
        "address": address,
        "DateOfEmployment": DateOfEmployment,
        "pic": pic,
        "branchId": branchId,
        "IsDeleted": IsDeleted,
      };

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      username: data['name'],
      email: data['email'],
      uid: data['UID'],
      phoneNumber: data['phone number'],
      userType: data['employeeType'],
      Age: data['age'],
      TagUid: data['Tag'],
      address: data['address'],
      DateOfEmployment: data['DateOfEmployment'],
      pic: data['pic'],
      branchId: data['branchId'],
      IsDeleted: data['IsDeleted']
    );
  }
}
