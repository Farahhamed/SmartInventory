import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Dashboard/sidebarDashboard.dart';
import 'package:smartinventory/screens/StockControl/ABCScreen.dart';
import 'package:smartinventory/screens/StockControl/CustomeDiscountScreen.dart';
import 'package:smartinventory/screens/StockControl/DiscountList.dart';
import 'package:smartinventory/screens/StockControl/FifoLifoScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StockControlPage(),
    );
  }
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class StockControlPage extends StatelessWidget {
  const StockControlPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavBarDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          child: AppBar(
            // backgroundColor: Color.fromRGBO(66, 125, 157, 0.2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              ),
            ),
            title: const Padding(
              padding: EdgeInsets.only(right: 16.0, top: 16.0),
              child: Center(
                child: Text('Stock Control'),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 16.0),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 16.0, top: 16.0),
                child: CircleAvatar(
                  radius: 16.0,
                  backgroundImage: AssetImage('assets/images/kitty.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 32.0,
          children: [
            GestureDetector(
              //Discounts
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CouponShape()),
                );
              },
              child: Container(
                height: 100.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://thumbs.dreamstime.com/b/promotional-mix-vector-concept-metaphor-sales-promotion-cartoon-web-icon-marketing-strategy-rebate-advertising-discount-offer-low-176602691.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Discounts',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(119, 176, 170, 1)),
                                    ),
                                    SizedBox(height: 4.0),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        'Set the discount for the products that need to be sold soon',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle onTap for Valuation MethodsonTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FifoLifoScreen()),
                );
              },
              child: Container(
                height: 120.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://cdn3.iconfinder.com/data/icons/isometric-illustrations-3/350/216-1024.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Valuation Methods',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(119, 176, 170, 1),
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        'Which products should go on shelves with FIFO and which go with LIFO',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle onTap for ABC Method
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDistributionPage()),
                );
              },
              child: Container(
                height: 120.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://th.bing.com/th/id/R.d727a87d6a54abe3c232c7c6b8b7852e?rik=J6DxLdE9CuHmcw&riu=http%3a%2f%2fbvlogic.academy%2fimages%2fcourses%2f1658032598.jpg&ehk=U1oFYBDQgXrmlKWBpgEhIcTOOvEixY9a9aQ9pTdBrtE%3d&risl=&pid=ImgRaw&r=0'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white.withOpacity(0.8),
                                  Colors.white.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ABC Method',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(119, 176, 170, 1),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Opacity(
                                      opacity: 0.9,
                                      child: Text(
                                        'ABC Method to divide products according to which is more important than others',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0,
          // Add your navigation bar content here
        ),
      ),
    );
  }
}
