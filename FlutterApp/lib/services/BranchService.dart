import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/BranchesModel.dart';
import 'package:uuid/uuid.dart';

class BranchService {
  final CollectionReference _branchesCollection =
      FirebaseFirestore.instance.collection('branches');

Future<bool> addBranch(String branchname) async {
  var uuid = Uuid().v4();

  // Check if the branch already exists
  QuerySnapshot querySnapshot = await _branchesCollection
      .where('name', isEqualTo: branchname)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    print('Branch with name ${branchname} already exists');
    return false; // Branch already exists
  }

  // Create the Branch object
  Branches branch = Branches(
    location: branchname,
    id: uuid,
    name: '',
  );

  // Add the branch to Firestore
  try {
    await _branchesCollection.doc(uuid).set(branch.toMap());
    return true; // Branch added successfully
  } catch (error) {
    print('Error adding branch: $error');
    return false; // Error occurred while adding branch
  }
}


  // Function to edit a branch
  Future<void> editBranch(Branches branch) async {
    await _branchesCollection.doc(branch.id).update(branch.toMap());
  }

  // Function to delete a branch
  Future<void> deleteBranch(String branchId) async {
    await _branchesCollection.doc(branchId).delete();
  }

  // Function to get all branches
  Stream<List<Branches>> getBranches() {
    return _branchesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Branches.fromSnapshot(doc))
        .toList());
  }

  // Function to get a branch by name
  Future<Branches> getBranchByName(String name) async {
    QuerySnapshot<Object?> querySnapshot =
        await _branchesCollection.where('name', isEqualTo: name).get();

    if (querySnapshot.docs.isNotEmpty) {
      return Branches.fromSnapshot(querySnapshot.docs.first);
    } else {
      return Branches(location: "", name: "", id: "");
    }
  }
}
