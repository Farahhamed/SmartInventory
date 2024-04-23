// import 'package:flutter/material.dart';

// class AddEmployeeScreen extends StatelessWidget {
//   final TextEditingController employeeNameController;
//   final TextEditingController jobTitleController;
//   final VoidCallback addEmployee;

//   const AddEmployeeScreen({
//     super.key,
//     required this.employeeNameController,
//     required this.jobTitleController,
//     required this.addEmployee,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Employee'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: employeeNameController,
//               style: const TextStyle(fontSize: 18),
//               decoration: const InputDecoration(
//                 labelText: 'Employee Name',
//                 labelStyle: TextStyle(fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: jobTitleController,
//               style: const TextStyle(fontSize: 18),
//               keyboardType: TextInputType.text,
//               decoration: const InputDecoration(
//                 labelText: 'Job Title',
//                 labelStyle: TextStyle(fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: addEmployee,
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.indigo, // Text color on button
//                 padding: const EdgeInsets.all(16.0),
//               ),
//               child: const Text(
//                 'Add New Employee',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Center(
            child: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF427D9D), // Start color
                      Color(0xFF9BBEC8), // End color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(File(_image!.path)),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('Your content goes here'),
        ),
      ),
    );
  }

  // Add image picker logic
  static late final ImagePicker _picker = ImagePicker();
  static XFile? _image;

  static Future<void> _getImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = pickedImage;
    }
  }
}
