import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

final orpc = OdooClient('http://localhost:8069');

void main() async {
  await orpc.authenticate('Smart_Inventory', 'admin', 'admin');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<dynamic> fetchContacts() {
    return orpc.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'email', '__last_update', 'image_128'],
        'limit': 80,
      },
    });
  }

  Widget buildListItem(Map<String, dynamic> record) {
    var unique = record['__last_update'] as String;
    unique = unique.replaceAll(RegExp(r'[⁰-9]'), '');
    final avatarUrl =
        '${orpc.baseURL}/web/image?model=res.partner&field=image_128&id=${record["id"]}&unique=$unique';
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      title: Text(record['name']),
      subtitle: Text(record['email'] is String ? record['email'] : ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchContacts(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Unable to fetch data');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data as List).length,
                itemBuilder: (context, index) {
                  final record = (snapshot.data as List)[index] as Map<String, dynamic>;
                  return buildListItem(record);
                },
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
