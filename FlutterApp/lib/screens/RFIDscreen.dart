import 'package:flutter/material.dart';
import 'package:smartinventory/RFID/MainPage.dart';
import 'package:smartinventory/RFID/writenfc.dart';

class RFIDscreen extends StatelessWidget {
  const RFIDscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RFID Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text('Read Tag'),
            ),
            SizedBox(height: 20), // Add space of 20 pixels between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WriteNFC()),
                );
              },
              child: Text('Write on Tag'),
            ),
          ],
        ),
      ),
    );
  }
}
