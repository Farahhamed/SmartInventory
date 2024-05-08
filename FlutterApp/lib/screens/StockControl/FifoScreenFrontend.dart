import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIFO Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FIFOInventoryPage(),
    );
  }
}

class ProductCategory {
  final String name;

  ProductCategory(this.name);
}

class FIFOInventoryPage extends StatefulWidget {
  @override
  _FIFOInventoryPageState createState() => _FIFOInventoryPageState();
}

class _FIFOInventoryPageState extends State<FIFOInventoryPage> {
  ProductCategory? _selectedCategory;
  List<ProductCategory> _categories = [
    ProductCategory('Category A'),
    ProductCategory('Category B'),
    ProductCategory('Category C'),
  ]; // Sample categories

  // Dummy product details
  String _productName = '';
  String _productTagNumber = '';
  String _dateOfEntry = '';
  String _dateOfExit = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FIFO Inventory'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a product to display FIFO:",
                style: TextStyle(
                    fontSize: 17, color: Color.fromRGBO(19, 93, 102, 1)),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<ProductCategory>(
                decoration: InputDecoration(
                  labelText: 'Products',
                  hintText: 'Choose a category',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 12),
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

                    // Reset product details when changing the category
                    _productName = '';
                    _productTagNumber = '';
                    _dateOfEntry = '';
                    _dateOfExit = '';
                  });
                },
              ),
              SizedBox(height: 50),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 32,
                        color: Color.fromRGBO(19, 93, 102, 1),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Name: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(219, 175, 160, 1)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Antinal",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.confirmation_number,
                        size: 30,
                        color: Color.fromRGBO(19, 93, 102, 1),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Tag Number: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(219, 175, 160, 1)),
                          ),
                          Text(
                            "EERF56",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 30,
                        color: Color.fromRGBO(19, 93, 102, 1),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Entry to Inventory: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(219, 175, 160, 1)),
                          ),
                          Text(
                            "10/1/2024",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_sharp,
                        size: 30,
                        color: Color.fromRGBO(19, 93, 102, 1),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Exit from Inventory: ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(219, 175, 160, 1)),
                          ),
                          Text(
                            "12/4/2024",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
