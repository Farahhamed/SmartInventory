import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AccessMonitoring.dart';
import 'package:smartinventory/screens/Dashboard/HomePageNew.dart';
import 'package:smartinventory/screens/EmployeesListScreen.dart';
import 'package:smartinventory/screens/Homepage.dart';
import 'package:smartinventory/screens/ProductsList.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EmployeeList(),
    ProductsList(),
    DashboardHomePage(),
    LogsWidgetScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // backgroundColor: Colors.transparent,
        color: const Color.fromRGBO(66, 125, 157, 1),
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Employees',
                    style: TextStyle(color: Colors.white, fontSize: 7)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Products',
                    style: TextStyle(color: Colors.white, fontSize: 7)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white), // Home icon
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Home',
                    style: TextStyle(color: Colors.white, fontSize: 7)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.lock, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Access Log',
                    style: TextStyle(color: Colors.white, fontSize: 7)),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Profile',
                    style: TextStyle(color: Colors.white, fontSize: 7)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
