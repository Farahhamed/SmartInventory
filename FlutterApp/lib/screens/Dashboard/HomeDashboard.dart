import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Container(
              color: Color.fromARGB(255, 139, 84, 251),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '  Financial Analysis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Arial',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/image-removebg-preview.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '\$58,471',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Positioned(
                top: 60.0,
                left: 50,
                right: 50,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 64),
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle Expenses tapped
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Expenses',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 40,
                                height: 2,
                                color: const Color.fromARGB(255, 195, 195, 195),
                              ),
                              const SizedBox(height: 10),
                              const Text('\$600'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Revenue tapped
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Revenue',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 40,
                                height: 2,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 10),
                              Text('\$900'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.all(32),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCategoryRow(
                        'assets/images/cold (2).png',
                        'Cold',
                        'Cold Medicine t5leek 100/100',
                        '\$500',
                      ),
                      _buildCategoryRow(
                        'assets/images/stomach.png',
                        'Stomach',
                        'Adwayet ll batn mya mya',
                        '\$700',
                      ),
                      _buildCategoryRow(
                        'assets/images/headache.png',
                        'Headach',
                        'Aw momken tshrab Redbull',
                        '\$300',
                      ),
                      _buildCategoryRow(
                        'assets/images/pain killers.png',
                        'Pain Killer',
                        'Da kalam fady tab3an zy ma kolena 3arfeen',
                        '\$900',
                      ),
                      _buildCategoryRow(
                        'assets/images/a5er category.png',
                        'Maghool',
                        'Brief description of Category 5',
                        '\$400',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 230.0,
          left: 0,
          right: 0,
          child: Center(
            child: Text('History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none, // Removing underline
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    String imageUrl,
    String name,
    String description,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            height: 40,
            width: 40,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
