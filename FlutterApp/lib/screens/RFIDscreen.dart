// import 'package:flutter/material.dart';
// import 'package:smartinventory/RFID/MainPage.dart';
// import 'package:smartinventory/RFID/writenfc.dart';

// class RFIDscreen extends StatelessWidget {
//   const RFIDscreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('RFID Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MainPage()),
//                 );
//               },
//               child: const Text('Read Tag'),
//             ),
//             const SizedBox(height: 20), // Add space of 20 pixels between buttons
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const WriteNFC()),
//                 );
//               },
//               child: const Text('Write on Tag'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smartinventory/RFID/MainPage.dart';
import 'package:smartinventory/RFID/writenfc.dart';
import 'package:smartinventory/screens/AssignTags.dart';
import 'package:smartinventory/screens/ReadWriteTags.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';

class RFIDscreen extends StatefulWidget {
  const RFIDscreen({super.key});

  @override
  State<RFIDscreen> createState() => _RFIDscreenState();
}

class _RFIDscreenState extends State<RFIDscreen> {
  bool agreePersonalData = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

    @override
  void dispose() {
    super.dispose();
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
                        'RFID Tags ',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReadWriteTags()),
                            );
                          },
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
                                : const Text('Read and Write on Tags  '),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                       SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: ()  {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssignTags()),
                            );
                          },
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
                                : const Text('Assign  Tags '),
                          ),
                        ),
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
