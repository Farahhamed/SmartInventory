import 'package:flutter/material.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';
import 'package:smartinventory/services/CategoriesServices.dart';
import 'package:smartinventory/widgets/FormScaffold.dart';
import 'package:uuid/uuid.dart';


class AddProductCategory extends StatefulWidget {
  const AddProductCategory({Key? key}) : super(key: key);

  @override
  State<AddProductCategory> createState() => _AddProductCategoryState();
}

class _AddProductCategoryState extends State<AddProductCategory> {
  String _productCategoryName = '';
    TextEditingController _productCategoryController = TextEditingController();
  final CategoryService _categoryService = CategoryService(); // Instantiate your category service

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
                        'Add new Product Category',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                    _buildTextField(
                      labelText: 'Product Category',
                      onChanged: (value) {
                        setState(() {
                          _productCategoryName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Submit Button
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addProductCategory, // Call _addProductCategory function
                          child: const Text('Add'),
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

  void _addProductCategory() async {
    //  var uuid= Uuid().v4();
    if (_productCategoryName.isNotEmpty) {
      // Add the product category using the service
      bool added = await _categoryService.addCategory( _productCategoryName);
      _productCategoryController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(added ? 'Category added successfully' : 'Category already exists'),
      ),
    );
    }
  }

  Widget _buildTextField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: _productCategoryController,
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
