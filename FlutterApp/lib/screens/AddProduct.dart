import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';
import 'package:smartinventory/services/CategoriesServices.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _productName = '';
  String _description = '';
  ProductCategory? _selectedCategory; // Default category
  double _price = 0.0;
  int _quantity = 0; // Initialize quantity

  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService(); // Instantiate your category service

  List<ProductCategory> _categories = [];

  File? _image;
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    _categoryService.getCategory().listen((categories) {
      setState(() {
        _categories = categories;
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
      });
    });
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

Future<void> _addProductToFirebase() async {
  try {
    if (_productName.isEmpty ||
        _description.isEmpty ||
        _selectedCategory == null ||
        _price <= 0 // Check if price is less than or equal to 0
) { // Check if quantity is less than or equal to 0
      return;
    }
     if (_image == null) {
        // Show error message if image is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return; // Return early if image is null
      }
    Product newProduct = Product(
      name: _productName,
      quantity: 0,
      description: _description,
      price: _price.toString(),
      categoryId: _selectedCategory!.id,
      imageUrl: '', // You can set the image URL if needed
      id: '', // You can set the ID if needed
    );
    bool success = await _productService.addProduct(newProduct,_image!);

     if (success) {
      setState(() {
        // Reset form fields
        _productName = '';
        _description = '';
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
        _price = 0.0;
        _image = null;
      });
     }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Product added successfully' : 'Product already exists'),
      ),
    );
  } catch (error) {
    print('Error adding product: $error');
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding product'),
      ),
    );
  }
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
                    DropdownButtonFormField<ProductCategory>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        hintText: 'Choose a category',
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
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem<ProductCategory>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
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
                    // Row(
                    //   children: [
                    //     const Text(
                    //       'Quantity',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //     Expanded(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               if (_quantity > 0) {
                    //                 setState(() {
                    //                   _quantity--;
                    //                 });
                    //               }
                    //             },
                    //             child: Container(
                    //               padding: const EdgeInsets.all(8),
                    //               decoration: const BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 color: Color.fromRGBO(155, 190, 200, 1),
                    //               ),
                    //               child: const Icon(Icons.remove),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 10),
                    //           Text(
                    //             '$_quantity',
                    //             style: const TextStyle(fontSize: 18),
                    //           ),
                    //           const SizedBox(width: 10),
                    //           InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 _quantity++;
                    //               });
                    //             },
                    //             child: Container(
                    //               padding: const EdgeInsets.all(8),
                    //               decoration: const BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 color: Color.fromRGBO(155, 190, 200, 1),
                    //               ),
                    //               child: const Icon(Icons.add),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: _buildTextField(
                    //         labelText: 'Quantity',
                    //         keyboardType: TextInputType.number,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _quantity = int.tryParse(value) ?? 0;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 30),
                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _addProductToFirebase, // Call the method to add product to Firebase
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(155, 190, 200, 1),
            ),
            child: const Icon(Icons.remove),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$value',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            onChanged?.call(value + 1);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(155, 190, 200, 1),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
