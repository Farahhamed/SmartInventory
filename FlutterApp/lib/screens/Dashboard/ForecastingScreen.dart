import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          bool isMorningShift = index % 2 == 0;
          String employeeName = 'Employee $index';
          String employeeRFID = 'RFID$index';
          int employeeNumber = 1000 + index;
          int employeeAge = 25 + index;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0, // Decreased elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: isMorningShift
                      ? const Color.fromARGB(255, 188, 175, 62)
                      : const Color.fromARGB(255, 36, 76, 108),
                  child: Icon(Icons.person),
                ),
                title: Text(employeeName),
                subtitle: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: isMorningShift
                            ? const Color.fromARGB(255, 188, 175, 62)
                            : const Color.fromARGB(255, 36, 76, 108),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        isMorningShift ? 'Morning Shift' : 'Night Shift',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('RFID: $employeeRFID'),
                    Text('Employee Number: $employeeNumber'),
                    Text('Age: $employeeAge'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 158, 125, 249),
        animationDuration: Duration(milliseconds: 300),
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
              Icon(Icons.home, color: Colors.white),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_graph, color: Colors.white),
              Text('Track', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings, color: Colors.white),
              Text('Settings',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white),
              Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
