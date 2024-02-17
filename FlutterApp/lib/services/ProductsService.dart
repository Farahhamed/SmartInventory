import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/get_products'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addProduct(String productName, double listPrice) async {
    final url = Uri.parse('http://127.0.0.1:5000/add_product');

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
}
