import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';

class AssignProduct extends StatefulWidget {
  const AssignProduct({super.key});

  @override
  State<AssignProduct> createState() => _AssignProductState();
}

class _AssignProductState extends State<AssignProduct> {
  bool agreePersonalData = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _tag = 'No assigned Tag yet';
  String _type = '';
  List<Product> _ProductType = [];
  String _selectedProductType = ' ';
  bool _isLoading = false;
  String taguid = 'No assigned Tag yet';
  String Payload = 'No Type';


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
       List<Product> FetchedProductList = [] ;
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();

       FetchedProductList = querySnapshot.docs
      .map((doc) => Product.fromSnapshot(doc)).cast<Product>().toList();
      // Set default value if needed
      if (FetchedProductList.isNotEmpty) {
        _selectedProductType = FetchedProductList[0].name;
      }
       print("Product Types: $FetchedProductList");

    setState(() {
    _ProductType = FetchedProductList;
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Save the form data to Firestore
      FirebaseFirestore.instance.collection('Assigned_Products').add({
        'ProductType': _selectedProductType,
        'UID': _tag,
      }).then((value) {
        // Successfully added data to Firestore

        // Show snackbar indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
      }).catchError((error) {
        // Handle errors here
        // Show snackbar indicating failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Product: $error')),
        );
      });
    }
  }

  String _convertToHexString(List<int> bytes) {
    return bytes
        .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
        .join(' ');
  }

  void _assignTag() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      // String taguid = 'No tag is detected';

      // We first check if NFC is available on the device.
      if (isAvailable) {
        // If NFC is available, start an NFC session and listen for NFC tags to be discovered.
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            // Process NFC tag, When an NFC tag is discovered, print its data to the console.
            debugPrint('NFC Tag Detected: $tag');
            NdefMessage message =
                NdefMessage([NdefRecord.createText('Product')]);
            await Ndef.from(tag)?.write(message);
            debugPrint('Data emitted successfully');
            List<int> payload =
                tag.data['ndef']['cachedMessage']['records'][0]['payload'];

            String payloadString = String.fromCharCodes(payload);
            payloadString = payloadString.substring(3, payloadString.length);
            Payload = payloadString;
            debugPrint('NFC Payload: $payloadString');
            debugPrint('all entries: ${tag.data['ndef']['identifier']}');

            taguid = _convertToHexString(tag.data['ndef']['identifier']);
            debugPrint('new id: $taguid');
          },
        );
      } else {
        debugPrint('NFC not available.');
      }
    } catch (e) {
      debugPrint('Error reading NFC: $e');
    }

    setState(() {
      _tag = taguid;
      _type = Payload;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        'Assign Tag to Products',
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
                        value: _selectedProductType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProductType = newValue!;
                          });
                        },
                        items: _ProductType.map((product) {
                          return DropdownMenuItem<String>(
                            value: product.name,
                            child: Text(product.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Product ',
                          hintText: 'Select Product ',
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
                      Row(
                        children: [
                          Text('$_tag'),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () => _assignTag(),
                            child: const Text('Read UID'),
                          ),
                          // const SizedBox(width: 20),
                          // Text('$_type')
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: 300,
                        child: InkWell(
                          onTap: () => _submitForm(context),
                          child: Container(
                            width: 300,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              color: Color.fromARGB(255, 174, 203, 227),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : const Text(
                                    'Add product ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
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
