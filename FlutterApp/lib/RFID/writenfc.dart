import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';



// class WriteNFC extends StatefulWidget {
//   const WriteNFC({super.key});

//   @override
//   _WriteNFCState createState() => _WriteNFCState();
// }

// class _WriteNFCState extends State<WriteNFC> {
//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('NFC Writer'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             DropdownButton<String>(
//               hint: const Text('Select a value'),
//               value: selectedValue,
//               onChanged: (String? value) {
//                 setState(() {
//                   selectedValue = value;
//                 });
//               },
//               items: <String>['Employee', 'Product'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _startNFCWriting(selectedValue);
//               },
//               child: const Text('Start NFC Writing'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';

class WriteNFC extends StatefulWidget {
  const WriteNFC({super.key});

  @override
  State<WriteNFC> createState() => _WriteNFCState();
}

class _WriteNFCState extends State<WriteNFC> {
  bool agreePersonalData = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedValueType = 'Employee';
  bool _isLoading = false;

    @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      Text(
                        'Write on Tags',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                       DropdownButtonFormField<String>(
                        value: _selectedValueType,
                        onChanged: (String? newValue) {
                          setState(() {
                           _selectedValueType = newValue!;
                          });
                        },
                        items: <String>['Employee', 'Product']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Tag Type',
                          hintText: 'Select Tag Type',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                       const SizedBox(
                        height: 40.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () => _startNFCWriting,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              color: Color.fromARGB(
                                  255, 174, 203, 227), // Adjust the color
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : const Text('Start NFC writing '),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}