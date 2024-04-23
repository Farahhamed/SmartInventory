import 'package:flutter/material.dart';

class FormScaffold extends StatelessWidget {
  final Widget body;

  const FormScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF427D9D), // Starting color
                  Color(0xFF9BBEC8), // Ending color
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: FormScaffold(
//       body: Center(
//         child: Text(
//           'Your form content goes here',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//   ));
// }
