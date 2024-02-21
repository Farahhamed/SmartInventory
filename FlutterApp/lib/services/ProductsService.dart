import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  String localhost = "http://127.0.0.1:5000";

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('$localhost/get_products'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addProduct(String productName, double listPrice) async {
    final url = Uri.parse('$localhost/add_product');

    try {
      final productData = {
        'name': productName,
        'list_price': listPrice,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(
            'Product added successfully. Product ID: ${responseData['product_id']}');
        // You can add any further actions or UI updates here
      } else {
        print('Failed to add product. Status code: ${response.statusCode}');
        // Handle error cases or display a message to the user
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateProduct(
      int productId, String newName, double newListPrice) async {
    final url = Uri.parse('$localhost/update_product');

    try {
      final productData = {
        'product_id': productId,
        'new_name': newName,
        'new_list_price': newListPrice,
      };

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(
            'Product updated successfully. Message: ${responseData['message']}');
        // You can add any further actions or UI updates here
      } else {
        print('Failed to update product. Status code: ${response.statusCode}');
        // Handle error cases or display a message to the user
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('$localhost/delete_product/$productId');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Product deleted successfully
        print('Product deleted successfully');
      } else if (response.statusCode == 404) {
        // Product not found
        print('Product not found');
      } else {
        // Handle other error cases
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }
}
