import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smartinventory/resources/auth_method.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartinventory/widgets/formScaffold.dart';

class AssignEmployee extends StatefulWidget {
  const AssignEmployee({super.key});

  @override
  State<AssignEmployee> createState() => _AssignEmployeeState();
}

class _AssignEmployeeState extends State<AssignEmployee> {
  bool agreePersonalData = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String _tag = 'No assigned Tag';
  String _type = '';
  String _selectedUserType = 'Manager';
  bool _isLoading = false;
  String taguid = 'No assigned Tag';
  String Payload = 'No Type';
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        ;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _passController.dispose();
    _phoneController.dispose();
  }

  Future<bool> checkTag() async {
    // Reference to the Firestore collection
    CollectionReference check =
        FirebaseFirestore.instance.collection('Register_employees');

    try {
      QuerySnapshot querySnapshot = await check.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        print(data["Tag"]);
        if (data["Tag"] == _tag) {
          return true;
        }
      }
    } catch (error) {
      // Handle errors
      print('Error checking tag: $error');
    }
    return false;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_tag == 'No assigned Tag') {
        // Show an error message if the tag has not been scanned
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please scan the tag')),
        );
        return; // Exit the method without submitting the form
      }
      if (await checkTag()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag already exists')),
        );
        return;
      }

      Map<String, dynamic> result = await AuthMethods().signUpUser(
          email: _emailController.text,
          username: _usernameController.text,
          password: _passController.text,
          phoneNumber: _phoneController.text,
          Age: _ageController.text,
          userType: _selectedUserType,
          TagUid: _tag,
          myimage: _image,
          address: _addressController.text);

      try {
        // Successfully added data to Firestore
        // Clear the form fields
        _usernameController.clear();
        _passController.clear();
        _emailController.clear();
        _phoneController.clear();
        _ageController.clear();
        _addressController.clear();
        _image = null;
        setState(() {
          _tag = 'No assigned Tag';
        });
        // Show snackbar indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee added successfully')),
        );
      } catch (error) {
        // Handle errors here
        // Show snackbar indicating failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add employee: $error')),
        );
      }
    }
  }

  String _convertToHexString(List<int> bytes) {
    return bytes
        .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
        .join(' ');
  }

  String RemoveZerosFromStart(String taguid) {
    String FinalResult = "";

    for (int i = 0; i < taguid.length; i++) {
      if (i % 3 == 0) {
        if (taguid[i] == '0') {
          continue;
        }
      }
      FinalResult += taguid[i];
    }
    return FinalResult;
  }

  void _assignTag() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      // String taguid = 'No tag is detected';

      // We first check if NFC is available on the device.
      if (isAvailable) {
        // If NFC is available, start an NFC session and listen for NFC tags to be discovered.
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            // Process NFC tag, When an NFC tag is discovered, print its data to the console.
            debugPrint('NFC Tag Detected: $tag');
            NdefMessage message =
                NdefMessage([NdefRecord.createText('Employee')]);
            await Ndef.from(tag)?.write(message);
            debugPrint('Data emitted successfully');
            List<int> payload =
                tag.data['ndef']['cachedMessage']['records'][0]['payload'];

            String payloadString = String.fromCharCodes(payload);
            payloadString = payloadString.substring(3, payloadString.length);
            Payload = payloadString;
            debugPrint('NFC Payload: $payloadString');
            debugPrint('all entries: ${tag.data['ndef']['identifier']}');

            taguid = _convertToHexString(tag.data['ndef']['identifier']);
            debugPrint('new id: $taguid');
          },
        );
      } else {
        debugPrint('NFC not available.');
      }
    } catch (e) {
      debugPrint('Error reading NFC: $e');
    }

    setState(() {
      _tag = RemoveZerosFromStart(taguid);
      _type = Payload;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      // extendBodyBehindAppBar: true,
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromARGB(255, 21, 90, 128), // Starting color
                //     Color.fromARGB(255, 29, 126, 153), // Ending color
                //   ],
                //   begin: Alignment.centerLeft,
                //   end: Alignment.centerRight,
                // ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      const Text(
                        'Add a new employee',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromRGBO(66, 125, 157, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //image
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      FileImage(File(_image!.path)),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU',
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: _getImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // full name
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          TextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Full name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter Username',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Age
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Your Age';
                              }
                              // Check if the entered value is a valid two-digit number
                              int age = int.tryParse(value)!;
                              if (age < 10 || age > 99) {
                                return 'Please enter a valid  age';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Age'),
                              hintText: 'Enter Your Age',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // phone number
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Phone Number';
                              }
                              // Check if the entered value is a valid phone number format
                              if (!RegExp(r'^(010|011|012|015)\d{8}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Phone Number'),
                              hintText: 'Enter a Phone Number',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      //Employee type
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedUserType,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedUserType = newValue!;
                              });
                            },
                            items: <String>['Manager', 'Supervisor', 'Employee']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              label: const Text('Employee Type'),
                              hintText: 'Choose a type',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.people,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //Address
                      Stack(
                        children: [
                          TextFormField(
                            controller: _addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Address'),
                              hintText: 'Enter Address',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.location_city,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              }
                              // Use a regular expression to validate email format
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Email'),
                              hintText: 'Enter Email',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 32, right: 12),
                          ),
                          TextFormField(
                            controller: _passController,
                            obscureText: true,
                            obscuringCharacter: '*',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('Password'),
                              hintText: 'Enter Password',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 55, right: 12),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFFBB8493),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.password_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // Stack(
                      //   children: [
                      //     _image != null
                      //         ? CircleAvatar(
                      //             radius: 64,
                      //             backgroundImage:
                      //                 FileImage(File(_image!.path)),
                      //           )
                      //         : const CircleAvatar(
                      //             radius: 64,
                      //             backgroundImage: NetworkImage(
                      //               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLorGAuZfVX3ZCV_Pz0QZlcOvXzPHKELhVPA&usqp=CAU',
                      //             ),
                      //           ),
                      //     Positioned(
                      //       bottom: -10,
                      //       left: 80,
                      //       child: IconButton(
                      //         onPressed: _getImage,
                      //         icon: const Icon(Icons.add_a_photo),
                      //       ),
                      //     )
                      //   ],
                      // ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          Text('$_tag'),
                          const SizedBox(width: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => _assignTag(),
                                child: Text(
                                  'Read UID',
                                  style: TextStyle(
                                      color: Colors
                                          .white), // Set text color to white
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 174, 203, 227),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                              ),
                            ],
                          ),

                          // const SizedBox(width: 20),
                          // Text('$_type')
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // save button
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () => _submitForm(context),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              color: Color.fromARGB(
                                  255, 174, 203, 227), // Adjust the color
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : const Text(
                                    'Read UID',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
