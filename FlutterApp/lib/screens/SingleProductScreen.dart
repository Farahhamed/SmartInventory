import 'package:flutter/material.dart';
import 'package:smartinventory/screens/ProductsList.dart';

void main() {
  runApp(ProductScreen());
}

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // Product photo
          Container(
            height: 400,
            width: double.infinity,
            child: Image.asset(
              'assets/images/oil.png',
              fit: BoxFit.cover,
            ),
          ),
          // First colored container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 350,
              padding: EdgeInsets.fromLTRB(30.0, 30.0, 25.0, 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 232, 232).withOpacity(0.95),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hemp Oil',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Used to strengthen the hair on a cellular level, hemp oil produces a protective layer to prevent and repair damage. Hemp oil can also be used to treat scalp conditions such as dandruff, and can stimulate the hair follicles and speed growth due to naturally occurring vitamin E.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF427D9D),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF427D9D),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hair products',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        '1500',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Second colored container with top-left border radius of 60px
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsList()),
                );
              },
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 19, 93, 102),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        'Number sold',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Text(
                        '1200',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsList()),
                  );
                },
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
