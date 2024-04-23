import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';
import 'package:input_quantity/input_quantity.dart'; // Import the QuantityInput widget

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _productName = '';
  String _description = '';
  String _selectedCategory = 'Cold'; // Default category
  double _price = 0.0;
  int _quantity = 0; // Initialize quantity

  File? _image;

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      child: Column(
        children: [
          Expanded(
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
                    Center(
                      child: Text(
                        'Add Product',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Image Selection
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _getImage,
                          child: Center(
                            child: _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: FileImage(_image!),
                                  )
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundImage: AssetImage(
                                      'assets/images/box.png',
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 230,
                          child: IconButton(
                            onPressed: _getImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      labelText: 'Product Name',
                      onChanged: (value) {
                        setState(() {
                          _productName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      labelText: 'Description',
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        hintText: 'Choose a category',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 20, right: 12),
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
                      value: _selectedCategory,
                      items: ['Cold', 'Pain Killer', 'Hair Products']
                          .map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Price
                    _buildTextField(
                      labelText: 'Price',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _price = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Quantity Input
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(fontSize: 18),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_quantity > 0) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        const Color.fromRGBO(155, 190, 200, 1),
                                  ),
                                  child: const Icon(Icons.remove),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$_quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _quantity++;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        const Color.fromRGBO(155, 190, 200, 1),
                                  ),
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _buildTextField(
                            labelText: 'Quantity',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _quantity = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement your form submission logic here
                            print('Product Name: $_productName');
                            print('Description: $_description');
                            print('Category: $_selectedCategory');
                            print('Price: $_price');
                            print('Quantity: $_quantity');
                          },
                          child: const Text('Add Product'),
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

class QuantitySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;

  const QuantitySelector({
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (value > 0) {
              onChanged?.call(value - 1);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(155, 190, 200, 1),
            ),
            child: const Icon(Icons.remove),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$value',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            onChanged?.call(value + 1);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(155, 190, 200, 1),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
