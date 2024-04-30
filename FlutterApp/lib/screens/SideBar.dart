import 'package:smartinventory/screens/AccessMonitoring.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
import 'package:smartinventory/screens/Notification.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('NohaElmasry'),
            accountEmail: Text('noha@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/kitty.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/blurryInventory.png'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text('Activity Log'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogsWidgetScreen()),
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
              // You can integrate Firebase authentication to handle user logout
            },
          ),
        ],
      ),
    );
  }
}
