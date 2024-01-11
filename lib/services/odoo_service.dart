// import 'package:http/http.dart' as http;
// import 'package:odoo_rpc/odoo_rpc.dart';

// class OdooService {
//   static Future<void> fetchProducts() async {
//     var url = Uri.parse('http://localhost:8069/api/Inventory');
//     var response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer a00476a022a8c453f31bcdd8028fdb6d27318efb',
//         // Other necessary headers or parameters
//       },
//     );

//     if (response.statusCode == 200) {
//       print('Products: ${response.body}');
//       // Handle response data accordingly
//     } else {
//       print('Failed to fetch products. Error: ${response.statusCode}');
//       // Handle error scenarios
//     }
//   }
// }
