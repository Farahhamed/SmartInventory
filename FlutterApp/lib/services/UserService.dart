import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/UserModel.dart';


class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) async {
    await usersCollection.add(user.toJson());
  }

  Future<void> updateUser(String userId, UserModel newData) async {
    await usersCollection.doc(userId).update(newData.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    final DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
    return snapshot.exists ? UserModel.fromSnapshot(snapshot) : null;
  }

  Future<void> deleteUser(String userId) async {
    await usersCollection.doc(userId).delete();
  }
}
