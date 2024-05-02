import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smartinventory/models/BranchesModel.dart';
import 'package:smartinventory/models/EmployeeTypeModel.dart';
import 'package:smartinventory/resources/auth_method.dart';
import 'package:smartinventory/services/BranchService.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';

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
  String _selectedBranchName = ' ';
  String _tag = 'No assigned Tag';
  String _type = '';
  bool _isLoading = false;
  String taguid = 'No assigned Tag';
  String Payload = 'No Type';
  File? _image;
  List<String>? branchLocations;
  List<String> branchids = [];
  String _selectedUserType = '';
  List<EmployeeType> _employeeTypes = [];
  bool isWriten = false;

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
  void initState() {
    super.initState();
    _getBranches();
    _fetchEmployeeTypes();
  }

  Future<void> _fetchEmployeeTypes() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('employee_type').get();

    setState(() {
      _employeeTypes = querySnapshot.docs
          .map((doc) => EmployeeType.fromFirestore(doc))
          .toList();
      // Set default value if needed
      if (_employeeTypes.isNotEmpty) {
        _selectedUserType = _employeeTypes[0].name;
      }
    });
  }

  String _getBranchIndex(String name) {
    int index = branchLocations!.indexOf(name);
    return branchids[index];
  }

  void _getBranches() {
    Stream<List<Branches>> branchesStream = BranchService().getBranches();

    branchesStream.listen((List<Branches> branches) {
      List<String> branchLocationslocal = [];
      List<String> branchidslocal = [];

      for (var branch in branches) {
        branchLocationslocal.add(branch.location);
        branchidslocal.add(branch.id);
      }
      setState(() {
        branchLocations = branchLocationslocal;
        branchids = branchidslocal;
      });
    });
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
    try {
      // Reference to the Firestore collection
      CollectionReference registerEmployeesCollection =
          FirebaseFirestore.instance.collection('Register_employees');

      // Check in Register_employees collection
      QuerySnapshot registerEmployeesSnapshot =
          await registerEmployeesCollection.where('Tag', isEqualTo: _tag).get();

      if (registerEmployeesSnapshot.docs.isNotEmpty) {
        return true;
      }

      // Reference to the Assigned_Products collection
      CollectionReference assignedProductsCollection =
          FirebaseFirestore.instance.collection('Assigned_Products');

      // Check in Assigned_Products collection
      QuerySnapshot assignedProductsSnapshot =
          await assignedProductsCollection.where('UID', isEqualTo: _tag).get();

      if (assignedProductsSnapshot.docs.isNotEmpty) {
        return true;
      }
    } catch (error) {
      // Handle errors
      print('Error checking tag: $error');
    }
    return false;
  }

  Future<bool> checkPhone() async {
    // Reference to the Firestore collection
    CollectionReference check =
        FirebaseFirestore.instance.collection('Register_employees');

    try {
      QuerySnapshot querySnapshot = await check.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        print(data["phone number"]);
        if (data["phone number"] == _phoneController.text) {
          return true;
        }
      }
    } catch (error) {
      // Handle errors
      print('Error checking tag: $error');
    }
    return false;
  }

  Future<bool> checkEmail() async {
    // Reference to the Firestore collection
    CollectionReference check =
        FirebaseFirestore.instance.collection('Register_employees');

    try {
      QuerySnapshot querySnapshot = await check.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        print(data["email"]);
        if (data["email"] == _emailController.text) {
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
      if (_image == null) {
        // Show error message if image is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return; // Return early if image is null
      }
      if (await checkTag()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag already exists')),
        );
        return;
      }
      if (!isWriten) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan again to write Product in the card')),
        );
        return;
      } else {
        setState(() {
          isWriten = false;
        });
      }
      if (await checkPhone()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone is already registered')),
        );
        return;
      }
      if (await checkEmail()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email is already in use')),
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
        address: _addressController.text,
        branchId: _getBranchIndex(_selectedBranchName),
      );

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
          SnackBar(content: Text(result['res'])),
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

            taguid = _convertToHexString(tag.data['ndef']['identifier']);
            debugPrint('new id: $taguid');

            setState(() {
              _tag = RemoveZerosFromStart(taguid);
              isWriten = false;
              // _type = Payload;
            });
            if (await checkTag()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tag is already assigned')),
              );
              return;
            }
            NdefMessage message =
                NdefMessage([NdefRecord.createText('Employee')]);
            await Ndef.from(tag)?.write(message);
            debugPrint('Data emitted successfully');
            setState(() {
              isWriten = true;
            });
            List<int> payload =
                tag.data['ndef']['cachedMessage']['records'][0]['payload'];

            String payloadString = String.fromCharCodes(payload);
            payloadString = payloadString.substring(3, payloadString.length);
            Payload = payloadString;
            debugPrint('NFC Payload: $payloadString');
            debugPrint('all entries: ${tag.data['ndef']['identifier']}');
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
      // _type = Payload;
      // isWriten = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
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
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      //Image upload
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
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
                      Stack(children: [
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
                            label: const Text('Full Name'),
                            hintText: 'Enter Full Name',
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
                              Icons.person,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 25.0,
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
                      Stack(children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32, right: 12),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),

                      //Employee type
                      Stack(children: [
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
                          items: _employeeTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type.name,
                              child: Text(type.name),
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
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // branch
                      Stack(children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32, right: 12),
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBranchName = newValue!;
                            });
                          },
                          items: branchLocations
                              ?.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Branch',
                            hintText: 'Select Branch',
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
                              Icons.store,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),

                      //address
                      Stack(children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32, right: 12),
                        ),
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
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      Stack(children: [
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
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      Stack(children: [
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
                      ]),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // Row(
                      //   children: [
                      //     Text('$_tag'),

                      //     const SizedBox(width: 50),
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         ElevatedButton(
                      //           onPressed: () => _assignTag(),
                      //           child: const Text(
                      //             'Read UID',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           style: ElevatedButton.styleFrom(
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(50),
                      //             ),
                      //             backgroundColor:
                      //                 Color.fromARGB(255, 174, 203, 227),
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: 16, vertical: 8),
                      //           ),
                      //         ),
                      //       ],
                      //     ),

                      //     // const SizedBox(width: 20),
                      //     // Text('$_type')
                      //   ],
                      // ),
                       Row(
                      children: [
                        Text('$_tag'),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: () => _assignTag(),
                          child: const Text('Read UID'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(112, 66, 100, 1),
                          ),
                        ),
                        // const SizedBox(width: 20),
                        // Text('$_type')
                      ],
                    ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () => _submitForm(context),
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              color: Color.fromRGBO(112, 66, 100, 1),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : Center(
                                    child: const Text(
                                      'Add Employee',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
