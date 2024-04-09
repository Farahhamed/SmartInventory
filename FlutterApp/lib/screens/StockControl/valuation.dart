import 'package:flutter/material.dart';

class ValuationPage extends StatefulWidget {
  @override
  _ValuationPageState createState() => _ValuationPageState();
}

class _ValuationPageState extends State<ValuationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Valuation'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            ValuationCard(
              icon: Icons.error_outline,
              iconColor: Color(0xFFFF8C94), // Pastel red
              title: 'Low Valuation Alert',
              content: 'The valuation for asset XYZ is lower than expected.',
            ),
            SizedBox(height: 10),
            ValuationCard(
              icon: Icons.warning,
              iconColor: Color(0xFFFFF59D), // Pastel yellow
              title: 'Medium Valuation Alert',
              content: 'The valuation for asset ABC is within caution levels.',
            ),
            SizedBox(height: 10),
            ValuationCard(
              icon: Icons.notification_important,
              iconColor: Color(0xFFCE93D8), // Soft purple
              title: 'High Valuation Alert',
              content: 'The valuation for asset DEF is higher than expected.',
            ),
          ],
        ),
      ),
    );
  }
}

class ValuationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;

  const ValuationCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE1BEE7), // Soft purple
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          padding: const EdgeInsets.all(8),
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(content),
      ),
    );
  }
}
