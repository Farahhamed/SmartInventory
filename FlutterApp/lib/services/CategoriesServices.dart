import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';

class CategoryService{
  final CollectionReference _categoryCollection =
    FirebaseFirestore.instance.collection('Categories');

Future<bool> addCategory(ProductCategory category) async {
    // Check if the product already exists
    QuerySnapshot querySnapshot = await _categoryCollection
        .where('name', isEqualTo: category.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('Product with name ${category.name} already exists');
      return false; // Product already exists
    }

    // Product doesn't exist, so add it
    await _categoryCollection.add(category.toMap());
    return true; // Product added successfully
  }

Future<void> editCategory(ProductCategory category) async {
  // Check if the product already exists
  QuerySnapshot querySnapshot = await _categoryCollection
      .where('name', isEqualTo: category.name)
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    print('Category with name ${category.name} does not exist');
    return; 
  }

  // Product exists, so edit it
  await _categoryCollection.doc(category.id).update(category.toMap());
}

Future<void> deleteCategory(String categoryId) async {
  await _categoryCollection.doc(categoryId).delete();
}

Stream<List<ProductCategory>> getCategory() {
  return _categoryCollection.snapshots().asyncMap((snapshot) async {
    List<ProductCategory> products = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      ProductCategory product = await ProductCategory.fromSnapshot(doc);
      products.add(product);
    }
    return products;
  });
}

Future<ProductCategory> getCategoryByName(String name) async {
    QuerySnapshot<Object?> querySnapshot =
        await _categoryCollection.where('name', isEqualTo: name).get();

    if (querySnapshot.docs.isNotEmpty) {
      return ProductCategory.fromSnapshot(querySnapshot.docs.first);
    } else {
      return ProductCategory(name: "", id: "");
    }
  }
}