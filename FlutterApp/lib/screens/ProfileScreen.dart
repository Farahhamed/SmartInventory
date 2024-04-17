import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/screens/EditProfile.dart';
import 'package:smartinventory/screens/Notification.dart';
import 'package:smartinventory/utilites/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;
  late Map<String, dynamic> userData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    }); 
    try{
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Register_employees')
          .doc(widget.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        setState(() {
          userData = userSnapshot.data()! as Map<String, dynamic>;
        });
      }
    }
  }
  catch (e) {
      showSnackBar(context, e.toString()); // show error in a snack bar
    }
    setState(() {
      isLoading = false; //after data is retrived, no more loading
    });

  }

  @override
  Widget build(BuildContext context) {
     return isLoading
        ? const Center(
            child:
                CircularProgressIndicator(), // if isLoading is true, show loading in ui
          )
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(userData['pic']),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['name'] ?? " ",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(userData['employeeType'] ?? ' '),
                    ],
                  ),
                ],
              ),

              // Bio Section
              const SizedBox(height: 16),
              const Text(
                'A member of the GoodGuardian family',
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 106, 180, 214), // Baby blue color
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: AutofillHints.countryName,
                          color: Color.fromARGB(255, 245, 249, 250)),
                    ),
                  ),
                ),
              ),
              // Personal Information Section
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 238, 239, 241),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 62, 62, 62)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Name:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['name'] ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Email:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['email'] ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Age:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['age'] ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Address:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['address'] ?? ' ay haga',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phone Number:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['phone number'] ?? ' ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 238, 239, 241),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employment Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 62, 62, 62)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Position:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['employeeType'] ?? ' ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Assigned Tag:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['Tag'] ?? ' ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Start Date:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(
                            userData['DateOfEmployment'] != null
                                ? '${(userData['DateOfEmployment'] as Timestamp).toDate().toLocal().toString().split(' ')[0]}'
                                : ' ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
