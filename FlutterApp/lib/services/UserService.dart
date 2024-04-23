import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartinventory/models/UserModel.dart';

class UserService {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('Register_employees');
     final FirebaseAuth _auth = FirebaseAuth.instance;

  // Deleting employee from Firestore and Firebase Authentication
  Future<void> deleteEmployee(String uid) async {
    try {
      employeeCollection.doc(uid).update({
      'IsDeleted': true,
    });
      // Delete from Firestore
      // await employeeCollection.doc(uid).delete();

      // // Delete from Firebase Authentication
      // await _auth.currentUser?.delete();
    } catch (err) {
      print('Error deleting employee: $err');
      throw err; // Rethrow the error for handling in UI
    }
  }
}
