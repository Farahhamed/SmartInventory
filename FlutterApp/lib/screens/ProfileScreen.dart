import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/screens/Notification.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        setState(() {
          userData = userSnapshot.data()! as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/images.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['username'] ?? 'John Doe',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(userData['userType'] ?? 'Software Engineer'),
                    ],
                  ),
                ],
              ),

              // Bio Section
              const SizedBox(height: 16),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Pellentesque nec metus vel ligula cursus consectetur.',
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
                            builder: (context) => NotificationPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
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
                        const Text('First Name:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['username'] ?? 'John',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Last Name:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['lastName'] ?? 'Doe',
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
                        Text(userData['address'] ?? '123 Main St',
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
                        Text(userData['phoneNumber'] ?? '123-456-7890',
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
                        const Text('Department:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['department'] ?? '24',
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
                        Text(userData['startDate'] ?? '20/2/2020',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('End Date:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['endDate'] ?? 'Present',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 64, 58, 58))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Employment Status:',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 64, 58, 58))),
                        Text(userData['employmentStatus'] ?? 'Active',
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
