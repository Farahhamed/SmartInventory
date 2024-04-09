import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home', style: TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder image URL
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10), // Added space above the first row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CardWidget(
                    icon: Icons.dashboard,
                    text: 'Dashboard',
                    count: '1',
                    color: Colors.purple[100]!,
                  ),
                ),
                SizedBox(width: 10), // Added space between the cards
                Expanded(
                  child: CardWidget(
                    icon: Icons.people,
                    text: 'Employees',
                    count: '100',
                    color: Colors.purple[100]!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Added space between the rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CardWidget(
                    icon: Icons.shopping_basket,
                    text: 'Products',
                    count: '50',
                    color: Colors.purple[100]!,
                  ),
                ),
                SizedBox(width: 10), // Added space between the cards
                Expanded(
                  child: CardWidget(
                    icon: Icons.attach_money,
                    text: 'Total Revenue',
                    count: '\$10000',
                    color: Colors.purple[100]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String count;
  final Color color;

  CardWidget({
    required this.icon,
    required this.text,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              count,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
