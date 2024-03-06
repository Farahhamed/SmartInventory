import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';



class WriteNFC extends StatefulWidget {
  const WriteNFC({Key? key}) : super(key: key);

  @override
  _WriteNFCState createState() => _WriteNFCState();
}

class _WriteNFCState extends State<WriteNFC> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Writer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('Select a value'),
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
              },
              items: <String>['Employee', 'Product'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startNFCWriting(selectedValue);
              },
              child: const Text('Start NFC Writing'),
            ),
          ],
        ),
      ),
    );
  }

  void _startNFCWriting(String? selectedValue) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
          try {
            NdefMessage message = NdefMessage([NdefRecord.createText(selectedValue ?? '')]);
            await Ndef.from(tag)?.write(message);
            debugPrint('Data emitted successfully');
            Uint8List payload = message.records.first.payload;
            String text = String.fromCharCodes(payload);
            debugPrint("Written data: $text");
            NfcManager.instance.stopSession();
          } catch (e) {
            debugPrint('Error emitting NFC data: $e');
          }
        });
      } else {
        debugPrint('NFC not available.');
      }
    } catch (e) {
      debugPrint('Error writing to NFC: $e');
    }
  }
}
