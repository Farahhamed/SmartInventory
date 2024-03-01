import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
            NotificationCard(
              icon: Icons.shopping_cart,
              iconColor: Colors.blue,
              title: 'Employee entered inventory',
              content:
                  'Hamza Saleh 24587SHET passed in : t547522sd at 19:50:35.',
            ),
            SizedBox(height: 10),
            NotificationCard(
              icon: Icons.exit_to_app,
              iconColor: Colors.red,
              title: 'Employee exited inventory',
              content:
                  'Hamza Saleh 24587SHET passed out : t547522sd at 19:50:35.',
            ),
            SizedBox(height: 10),
            NotificationCard(
              icon: Icons.warning,
              iconColor: Colors.yellow,
              title: 'Low stock warning',
              content: 'Shampoo O\'real will be out of stock on 5/4',
            ),
            SizedBox(height: 10),
            NotificationCard(
              icon: Icons.exit_to_app,
              iconColor: Colors.red,
              title: 'Employee exited inventory',
              content:
                  'Hamza Saleh 24587SHET passed out : t547522sd at 19:50:35.',
            ),
            SizedBox(height: 10),
            NotificationCard(
              icon: Icons.exit_to_app,
              iconColor: Colors.red,
              title: 'Employee exited inventory',
              content:
                  'Hamza Saleh 24587SHET passed out : t547522sd at 19:50:35.',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(content),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
