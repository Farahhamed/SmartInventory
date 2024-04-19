import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardHomePage(),
    );
  }
}

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({Key? key}) : super(key: key);

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image and content
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/blurHomePage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          //
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {
                          //
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Budget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '\$12000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        'Total balance',
                        style: TextStyle(
                          color: Color.fromRGBO(119, 176, 170, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 220.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First Card
                  SizedBox(
                    height: 135.0,
                    width: 175.0,
                    child: Card(
                      elevation: 4,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Custom content for the first card
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9BBEC8),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/pay.png",
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Spending',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$1200',
                                style: TextStyle(
                                  color: Color(0xFF135D66),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'From Balance',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0),

                  // Second Card
                  SizedBox(
                    height: 135.0,
                    width: 175.0,
                    child: Card(
                      elevation: 4,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9BBEC8),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/balance.png",
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$1500',
                                style: TextStyle(
                                  color: Color(0xFF135D66),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Balance left',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 380.0,
            left: 12.0,
            right: 12.0,
            bottom: 12.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFBB8493),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(right: 16),
                                child: Image.asset(
                                    "assets/images/pain killers.png"),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Panadol',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Pain Killer Category',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$1200',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Successful',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(119, 176, 170, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
