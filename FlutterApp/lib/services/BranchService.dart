import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/BranchesModel.dart';

class BranchService {
  final CollectionReference _branchesCollection =
      FirebaseFirestore.instance.collection('branches');

  // Function to add a branch
  Future<void> addBranch(Branches branch) async {
    await _branchesCollection.add(branch.toMap());
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
