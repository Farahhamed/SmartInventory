import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/screens/AssignEmployee.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';
import 'package:smartinventory/screens/SideBar.dart';
import 'package:smartinventory/services/UserService.dart'; // Import your UserService

enum UserType { Manager, Employee }

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  late TextEditingController _searchController;
  final UserService _userService = UserService(); // Initialize UserService
  UserType _userType = UserType.Employee;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getUserType();
  }

  Future<void> _getUserType() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Register_employees')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        dynamic userData = userSnapshot.data();
        String? userType = userData?['employeeType'] as String?;

        if (userType == 'Manager') {
          setState(() {
            _userType = UserType.Manager;
          });
        } else {
          setState(() {
            _userType = UserType.Employee;
          });
        }
      }
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 16.0), // Add padding horizontally
      child: Scaffold(
        key: scaffoldKey,
        drawer: NavBar(),
        appBar: AppBar(
          title: Row(
            children: [
              Center(child: Text('  Employees List  ')),
              Spacer(),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            if (_userType == UserType.Manager)
            Ink(
              decoration: const BoxDecoration(
                color: Color(0xFFBB8493),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssignEmployee()),
                  );
                },
                tooltip: 'Add Employee',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild on text change
                },
                cursorHeight: 35,
                decoration: InputDecoration(
                  hintText: 'Search for an Employee',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Register_employees')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No employees found.'),
                    );
                  }

                  // Filter the documents based on the case-insensitive search query
                  var filteredDocs = snapshot.data!.docs
                      .where((document) {
                        var name = (document['name'] ?? '')
                            .toLowerCase(); // Convert to lowercase
                        var searchQuery = _searchController.text
                            .trim()
                            .toLowerCase(); // Convert to lowercase
                        return name.contains(searchQuery);
                      })
                      .where((element) =>
                          element['IsDeleted'] == false &&
                          element['UID'] !=
                              FirebaseAuth.instance.currentUser?.uid)
                      .toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text('No matching employees found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = filteredDocs[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: document['UID']),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading:CircleAvatar(
                                radius: 60,
                                child: ClipOval(
                                  child: Image.network(document['pic'],fit: BoxFit.fill,),
                                ),
                                // backgroundImage: NetworkImage(document['pic']),
                                
                              ),
                              title: Text(
                                document['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(' ${document['Tag'] ?? ''}'),
                                  Text('${document['employeeType'] ?? ''}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // IconButton(
                                  //   icon: Icon(Icons.edit),
                                  //   onPressed: () {
                                  //     // Implement edit functionality
                                  //   },
                                  // ),
                                  if (_userType == UserType.Manager)
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      // Show a confirmation dialog before deleting
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Delete Employee'),
                                            content: Text(
                                                'Are you sure you want to delete this employee?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _userService.deleteEmployee(
                                                      document[
                                                          'UID']); // Call delete function from UserService
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
