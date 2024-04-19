import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartinventory/models/UserModel.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Get user details from Firestore.
  Future<UserModel> getUserDetails() async {
    User? currentUser =
        _auth.currentUser; // Get the current authenticated user.
    if (currentUser != null) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('Register_employees')
          .doc(currentUser.uid)
          .get(); // Get the user document from Firestore.
      return UserModel.fromSnapshot(
          snap); // Create a UserModel object from the Firestore document.
    } else {
      throw Exception("User not authenticated");
    }
  }

  Future<Map<String, dynamic>> signUpUser({
    required String email,
    required String username,
    required String password,
    required String phoneNumber,
    required String userType,
    required String Age,
    String UID = '',
    required String TagUid,
    File? myimage,
    required String address,
  }) async {
    Map<String, dynamic> result = {"res": "Error occurred"};
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          userType.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Firebase automatically generates UID
        String uid = cred.user!.uid;
        String pic;
        if (myimage != null) {
          // User? currentUser = FirebaseAuth.instance.currentUser;
          try {
            final ref =
                FirebaseStorage.instance.ref().child('ProfilePicture/$uid/pic');
            await ref.putFile(myimage!);
            pic = await ref.getDownloadURL();
            UserModel user = UserModel(
              username: username,
              email: email,
              uid: uid,
              phoneNumber: phoneNumber,
              userType: userType,
              Age: Age,
              TagUid: TagUid,
              address: address,
              pic: pic,
              DateOfEmployment: DateTime.now(),
            );

            await _firestore.collection('Register_employees').doc(uid).set(
                  user.toJson(),
                );
        result["res"] = "success";
        result["user"] = user;
          } catch (e) {
            print('error occured');
          }
        }

      } else {
        result["res"] = "User registration failed";
      }
    } catch (err) {
      result["res"] = err.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    String res =
        "Error Occurred"; // Initialize the result variable with an error message.

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log in user with email and password.
        final credentials = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return {
          "res": credentials.user,
          "error": false
        }; // Return user credentials and set error to false.
      } else {
        return {
          "res": "Please enter all the fields",
          "error": true
        }; // Return a message and set error to true if fields are empty.
      }
    } catch (err) {
      res =
          "Error: ${err.toString()}"; // Set result to the error message if an exception occurs.
      return {
        "res": res,
        "error": true
      }; // Return the result and set error to true.
    }
  }

  Future<String> getUserTypeFromFirestore(String uid) async {
    try {
      // Access Firestore collection "users" and document with the provided UID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Register_employees')
          .doc(uid)
          .get();

      // Check if the document exists
      if (snapshot.exists) {
        // Get the data from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Check if the user type field exists in the document
        if (data.containsKey('employeeType')) {
          // Return the user type
          return data['employeeType'];
        } else {
          // User type field does not exist, handle accordingly
          return 'Unknown';
        }
      } else {
        // Document does not exist, handle accordingly
        return 'Unknown';
      }
    } catch (error) {
      // Error occurred, handle accordingly
      print('Error fetching user type: $error');
      return 'Unknown';
    }
  }
}
