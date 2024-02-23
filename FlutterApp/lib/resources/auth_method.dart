import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/UserModel.dart';
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
          .collection('users')
          .doc(currentUser.uid)
          .get(); // Get the user document from Firestore.
      return UserModel.fromSnapshot(
          snap); // Create a UserModel object from the Firestore document.
    } else {
      throw Exception("User not authenticated");
    }
  }

  Future<Map<String, dynamic>> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> result = {"res": "Error occurred"};
    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Firebase automatically generates UID
        String uid = cred.user!.uid;

        UserModel user = UserModel(
          username: username,
          email: email,
          uid: uid,
        );

        await _firestore.collection('users').doc(uid).set(
              user.toJson(),
            );

        result["res"] = "success";
        result["user"] = user;
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
}
