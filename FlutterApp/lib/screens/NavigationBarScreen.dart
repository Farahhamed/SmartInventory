import 'package:flutter/material.dart';
import 'package:smartinventory/screens/ActivityLogScreen.dart';
import 'package:smartinventory/screens/AssignTags.dart';
import 'package:smartinventory/screens/EmployeesListScreen.dart';
import 'package:smartinventory/screens/ProductsList.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:smartinventory/screens/RFIDscreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ActivityLogUI(),
    EmployeeList(),
    const ProductsList(),
    const AssignTags(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 177, 157, 234),
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
                icon: const Icon(Icons.timeline, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              const Text('Activity',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              const Text('Employees',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              const Text('Products',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.tag, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              const Text('RFID',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
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
              const Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
