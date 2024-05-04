import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/ProductsService.dart';


class FifoLifoScreen extends StatefulWidget {
  @override
  _FifoLifoScreenState createState() => _FifoLifoScreenState();
}

class _FifoLifoScreenState extends State<FifoLifoScreen> {
  late Stream<List<Product>> _productsStream;
  String _sortOrder = 'FIFO'; // Default to FIFO

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsStream = ProductService().getProductsOrder(sortOrder: _sortOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _sortOrder,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortOrder = newValue;
                  _loadProducts();
                });
              }
            },
            items: <String>['FIFO', 'LIFO']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Product> products = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('Order Date: ${product.orderDateTime}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
