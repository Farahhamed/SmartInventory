import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smartinventory/resources/auth_method.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';

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
  String _tag = 'No assigned Tag';
  String _type = '';
  String _selectedUserType = 'Manager';
  bool _isLoading = false;
  String taguid = 'No assigned Tag';
  String Payload = 'No Type';

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
  CollectionReference check = FirebaseFirestore.instance.collection('Register_employees');

  try {
    
    QuerySnapshot querySnapshot = await check.get();

   for(QueryDocumentSnapshot document in querySnapshot.docs ){
      final data = document.data() as Map<String, dynamic>;
      print(data["Tag"]);
      if(data["Tag"] == _tag){
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
      if(await checkTag()){
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
      TagUid: taguid,
    );

    try {
      // Successfully added data to Firestore
      // Clear the form fields
      _usernameController.clear();
      _passController.clear();
      _emailController.clear();
      _phoneController.clear();
      _ageController.clear();
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
      _tag = taguid;
      _type = Payload;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
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
                      Text(
                        'Assign Tag to employee',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
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
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // Age
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // phone number
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
                          hintText: 'Enter Phone Number',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      //Employee type
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
                          labelText: 'Employee Type',
                          hintText: 'Select Employee Type',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
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
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
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
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          Text('$_tag'),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () => _assignTag(),
                            child: const Text('Read UID'),
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
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
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
                                : const Text('Add Employee'),
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
