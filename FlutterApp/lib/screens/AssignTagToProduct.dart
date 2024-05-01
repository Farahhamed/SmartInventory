import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/themes/theme.dart';
import 'package:smartinventory/widgets/CustomScaffold.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';

class AssignTagToProduct extends StatefulWidget {
  const AssignTagToProduct({super.key});

  @override
  State<AssignTagToProduct> createState() => _AssignTagToProductState();
}

class _AssignTagToProductState extends State<AssignTagToProduct> {
  bool agreePersonalData = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _tag = 'No assigned Tag yet';
  String _type = '';
  List<Product> _ProductType = [];
  String _selectedProductType = ' ';
  bool _isLoading = false;
  String taguid = 'No assigned Tag yet';
  String Payload = 'No Type';

  Product? _selectedProduct;

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
    List<Product> FetchedProductList = [];
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();

    FetchedProductList = querySnapshot.docs
        .map((doc) => Product.fromSnapshot(doc))
        .cast<Product>()
        .toList();
    // Set default value if needed
    if (FetchedProductList.isNotEmpty) {
      _selectedProductType = FetchedProductList[0].name;
    }

    setState(() {
      _ProductType = FetchedProductList;
    });
  }

  Future<bool> checkTag() async {
    try {
      // Reference to the Firestore collection
      CollectionReference registerEmployeesCollection =
          FirebaseFirestore.instance.collection('Register_employees');

      // Check in Register_employees collection
      QuerySnapshot registerEmployeesSnapshot =
          await registerEmployeesCollection.where('Tag', isEqualTo: _tag).get();

      if (registerEmployeesSnapshot.docs.isNotEmpty) {
        return true;
      }

      // Reference to the Assigned_Products collection
      CollectionReference assignedProductsCollection =
          FirebaseFirestore.instance.collection('Assigned_Products');

      // Check in Assigned_Products collection
      QuerySnapshot assignedProductsSnapshot =
          await assignedProductsCollection.where('UID', isEqualTo: _tag).get();

      if (assignedProductsSnapshot.docs.isNotEmpty) {
        return true;
      }
    } catch (error) {
      // Handle errors
      print('Error checking tag: $error');
    }
    return false;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_tag == 'No assigned Tag yet') {
        // Show an error message if the tag has not been scanned
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please scan the tag')),
        );
        return; // Exit the method without submitting the form
      }
      if (_selectedProduct == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a product')),
        );
        return; // Exit the method without submitting the form
      }
      if (await checkTag()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag already exists')),
        );
        return;
      }
      String selectedProductId = _ProductType.firstWhere(
          (product) => product.name == _selectedProductType).id;
      // Save the form data to Firestore
      FirebaseFirestore.instance.collection('Assigned_Products').add({
        'ProductId': selectedProductId,
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
    return FormScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Assign Tag To Product',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Category Dropdown
                    DropdownButtonFormField<Product>(
                      decoration: InputDecoration(
                        labelText: 'Product',
                        hintText: 'Choose Product',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 20, right: 12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFBB8493),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFBB8493),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedProduct,
                      items: _ProductType.map((product) {
                        return DropdownMenuItem<Product>(
                          value: product,
                          child: Text(product.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProduct = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      children: [
                        Text('$_tag'),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: () => _assignTag(),
                          child: const Text('Read UID'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(112, 66, 100, 1),
                          ),
                        ),
                        // const SizedBox(width: 20),
                        // Text('$_type')
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _submitForm(
                                context); // Call the method to add product to Firebase
                          }, // Call the method to add product to Firebase
                          child: const Text('Assign Tag to Product'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(112, 66, 100, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter $labelText',
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFBB8493),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFBB8493),
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
