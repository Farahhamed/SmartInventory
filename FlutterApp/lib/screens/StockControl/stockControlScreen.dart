import 'package:flutter/material.dart';

class StockControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 32.0, // Increased spacing between items
          children: [
            GestureDetector(
              onTap: () {
                // Handle onTap for Discounts
              },
              child: Card(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Background image here
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://thumbs.dreamstime.com/b/promotional-mix-vector-concept-metaphor-sales-promotion-cartoon-web-icon-marketing-strategy-rebate-advertising-discount-offer-low-176602691.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Text with semi-transparent white background
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Discounts',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      'Set the discount for the products that need to be sold soon',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.purple,
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
            GestureDetector(
              onTap: () {
                // Handle onTap for Valuation Methods
              },
              child: Card(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Background image here
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://cdn3.iconfinder.com/data/icons/isometric-illustrations-3/350/216-1024.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Text with semi-transparent white background
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Valuation Methods',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      'Which products should go on shelves with FIFO and which go with LIFO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.purple,
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
            GestureDetector(
              onTap: () {
                // Handle onTap for ABC Method
              },
              child: Card(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Background image here
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://th.bing.com/th/id/R.d727a87d6a54abe3c232c7c6b8b7852e?rik=J6DxLdE9CuHmcw&riu=http%3a%2f%2fbvlogic.academy%2fimages%2fcourses%2f1658032598.jpg&ehk=U1oFYBDQgXrmlKWBpgEhIcTOOvEixY9a9aQ9pTdBrtE%3d&risl=&pid=ImgRaw&r=0'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Text with semi-transparent white background
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
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ABC Method',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      'ABC Method to divide products according to which is more important than others',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.purple,
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
