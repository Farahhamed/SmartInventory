import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AccessMonitoring.dart';
import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
import 'package:smartinventory/screens/Dashboard/NavBarDashboard.dart';
// import 'package:smartinventory/screens/Dashboard/testAPI.dart';
import 'package:smartinventory/screens/LoginScreen.dart';
import 'package:smartinventory/screens/Notification.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';
import 'package:smartinventory/utilites/utils.dart';
import 'package:smartinventory/screens/drug_checker.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late User? currentUser;
  late Map<String, dynamic> userData = {};
  bool isLoading = false;
  String accountName = 'NohaElmasry';
  String accountEmail = 'noha@gmail.com';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Register_employees')
            .doc(currentUser!.uid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> fetchedUser =
              userSnapshot.data() as Map<String, dynamic>;
          DocumentSnapshot branchSnapshot = await FirebaseFirestore.instance
              .collection('branches')
              .doc(fetchedUser['branchId'])
              .get();
          Map<String, dynamic> fetchedBranch =
              branchSnapshot.data() as Map<String, dynamic>;
          setState(() {
            userData = fetchedUser;
          });
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString()); // show error in a snack bar
    }
    setState(() {
      isLoading = false; // after data is retrieved, no more loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to another page here
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(uid: currentUser?.uid ?? '')),
              );
            },
            child: UserAccountsDrawerHeader(
              accountName: Text(userData['name'] ?? ""),
              accountEmail: Text(userData['email'] ?? ""),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: userData.containsKey('pic')
                    ? NetworkImage(userData['pic'])
                    : AssetImage('assets/images/kitten.png') as ImageProvider,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/blurryInventory.png'),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Stock Control'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavbarDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text('FDA'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DrugChecker()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notification'),
                ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        '8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Perform user logout
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
