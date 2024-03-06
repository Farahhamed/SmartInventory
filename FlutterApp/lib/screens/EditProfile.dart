// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController bioController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();

//   final _userService = UserService(); // Create an instance of your user service

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData(); // Fetch user data when the page is initialized
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Fetch user data from Firestore using your user service
//         UserModel? userData = await _userService.getUser(user.uid);
//         if (userData != null) {
//           // Set the user data in the text controllers
//           firstNameController.text = userData.firstName;
//           lastNameController.text = userData.lastName;
//           bioController.text = userData.bio;
//           addressController.text = userData.address;
//           phoneNumberController.text = userData.phoneNumber;
//         }
//       }
//     } catch (error) {
//       // Handle errors
//       print('Error fetching user data: $error');
//     }
//   }

//   Future<void> _updateUserData() async {
//     try {
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Create a new UserModel with updated data
//         UserModel updatedUser = UserModel(
//           username: user.displayName ?? '',
//           email: user.email ?? '',
//           uid: user.uid,
//           phoneNumber: phoneNumberController.text,
//           userType: '', // Add your logic to get userType
//         );

//         // Update user data using your user service
//         await _userService.updateUser(user.uid, updatedUser);
//         // Navigate back to the previous screen
//         Navigator.pop(context);
//       }
//     } catch (error) {
//       // Handle errors
//       print('Error updating user data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 10, 65, 110),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.transparent,
//         title: const Center(
//           child: Text(
//             'Edit Profile',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 7,
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Stack(
//                         children: [
//                           Positioned(

//                           top: 0,
//                           left: -50,
//                           right: -50,
//                           bottom: 0,
//                           child: Container(
//                             color: Colors.transparent,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(150),
//                                         topLeft: Radius.circular(250),
//                                       ),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(150),
//                                         topRight: Radius.circular(250),
//                                       ),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: MediaQuery.of(context).size.height * 0.15 - 100,
//                           left: MediaQuery.of(context).size.width * 0.5 - 50,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       color: const Color.fromARGB(
//                                           255, 251, 250, 250),
//                                       width: 5),
//                                 ),
//                                 child: const Center(
//                                   child: CircleAvatar(
//                                     radius: 50,
//                                     backgroundImage:
//                                         AssetImage('assets/images/kitty.png'),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 5,
//                                 child: Container(
//                                   width: 30,
//                                   height: 30,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: const Color.fromARGB(255, 255, 255, 255),
//                                     border: Border.all(
//                                         color: const Color.fromARGB(255, 16, 1, 101),
//                                         width: 2),
//                                   ),
//                                   child: Center(
//                                     child: IconButton(
//                                       icon: const Icon(Icons.edit),
//                                       onPressed: () {
//                                         // edit functionality here
//                                       },
//                                       color: const Color.fromARGB(255, 16, 1, 101),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Positioned(
//                           top: MediaQuery.of(context).size.height * 0.15,
//                           left: 0,
//                           right: 0,
//                           bottom: 0,
//                           child: Container(
//                             color: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20.0, vertical: 20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: TextFormField(
//                                         decoration: InputDecoration(
//                                           hintText: 'First Name',
//                                           fillColor: Colors.grey[200],
//                                           filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         width:
//                                             20), // Add space between text fields
//                                     Expanded(
//                                       child: TextFormField(
//                                         decoration: InputDecoration(
//                                           hintText: 'Last Name',
//                                           fillColor: Colors.grey[200],
//                                           filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Row(
//                                   children: [
//                                     const Text(
//                                       'Gender',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 20),
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           Transform.scale(
//                                             scale: 1.0,
//                                             child: Radio(
//                                               value: 'male',
//                                               groupValue: '',
//                                               onChanged: (value) {},
//                                               activeColor: Colors.blue,
//                                             ),
//                                           ),
//                                           const Text(
//                                             'Male',
//                                             style: TextStyle(
//                                               fontSize:
//                                                   16, // Increase the font size
//                                             ),
//                                           ),
//                                           const SizedBox(width: 20),
//                                           Transform.scale(
//                                             scale: 1.0,
//                                             child: Radio(
//                                               value: 'female',
//                                               groupValue: '',
//                                               onChanged: (value) {},
//                                               activeColor: Colors.blue,
//                                             ),
//                                           ),
//                                           const Text(
//                                             'Female',
//                                             style: TextStyle(
//                                               fontSize:
//                                                   16, // Increase the font size
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                     height:
//                                         20), // Add space between radio buttons and text fields
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Bio',
//                                     fillColor: Colors.grey[200],
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   maxLines: 3, // Make the text field bigger
//                                 ),
//                                 const SizedBox(
//                                     height:
//                                         20), // Add space between text fields
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Address',
//                                     fillColor: Colors.grey[200],
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                     height:
//                                         20), // Add space between text fields
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Phone Number',
//                                     fillColor: Colors.grey[200],
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: ElevatedButton.icon(
//                                         onPressed: () {
//                                           // Save functionality here
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           primary: Colors.green,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                         ),
//                                         icon: const Icon(
//                                           Icons.check,
//                                           color: Colors.white,
//                                         ),
//                                         label: const Text(
//                                           'Save',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 20),
//                                     Expanded(
//                                       child: ElevatedButton.icon(
//                                         onPressed: () {
//                                           // Cancel functionality here
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           primary: Colors.grey,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                         ),
//                                         icon: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                         ),
//                                         label: const Text(
//                                           'Cancel',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
