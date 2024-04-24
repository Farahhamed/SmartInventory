// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:smartinventory/models/EmployeeTypeModel.dart';


// class EmployeeTypeService {
//     final CollectionReference _EmployeeTypeCollection =
//       FirebaseFirestore.instance.collection('employee_type');

//  Future<List<EmployeeType>> fetchEmployeeTypes() async {
//     final QuerySnapshot querySnapshot =
//         await _EmployeeTypeCollection.get();
//         return querySnapshot.docs
//           .map((doc) => EmployeeType.fromFirestore(doc))
//           .toList();
//     // setState(() {
//     //   _employeeTypes = querySnapshot.docs
//     //       .map((doc) => EmployeeType.fromFirestore(doc))
//     //       .toList();
//     //   // Set default value if needed
//     //   if (_employeeTypes.isNotEmpty) {
//     //     _selectedUserType = _employeeTypes[0].name;
//     //   }
//     // });
//   }

// }