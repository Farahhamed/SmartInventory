
// import 'package:flutter/material.dart';
// import 'package:odoo_rpc/odoo_rpc.dart'; 

// class OdooConnectionWidget extends StatefulWidget {
//   @override
//   _OdooConnectionWidgetState createState() => _OdooConnectionWidgetState();
// }

// class _OdooConnectionWidgetState extends State<OdooConnectionWidget> {
//   OdooClient client = OdooClient('http://localhost:8069/xmlrpc/2/common');

//   Future<void> connectToOdoo() async {
//     try {
//       final authResult = await client.authenticateWeb(
//         'Smart_Inventory', 
//         'admin', 
//         'admin',
//       );
      
//       if (authResult.isSuccess) {
//         print('Authenticated successfully');
//         // Continue using the same client for subsequent calls
//         final res = await client.callRPC('/web/session/modules', 'call', {});
//         print('Installed modules: \n' + res.toString());
//       } else {
//         print('Authentication failed');
//       }
//     } on OdooException catch (e) {
//       print(e);
//       // Handle the error in your app accordingly
//     }
//   }


//   @override
//   void initState() {
//     super.initState();
//     connectToOdoo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // You can return any widget you want here
//     return Container();
//   }

//   @override
//   void dispose() {
//     client.close();
//     super.dispose();
//   }
// }
