// import 'package:flutter/material.dart';
// import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
// import 'package:smartinventory/screens/EmployeesListScreen.dart';
// import 'package:smartinventory/screens/ProductsList.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: HomePageScreen(),
// //     );
// //   }
// // }

// class HomePageScreen extends StatefulWidget {
//   const HomePageScreen({Key? key}) : super(key: key);

//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }

// class _HomePageScreenState extends State<HomePageScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(20.0),
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(220.0),
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(180),
//                   bottomRight: Radius.circular(20),
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 child: Image.asset(
//                   'assets/images/appbar.png',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity,
//                 ),
//               ),
//               Positioned.fill(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(180),
//                     bottomRight: Radius.circular(20),
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child: Container(
//                     color: Colors.black.withOpacity(0.4),
//                   ),
//                 ),
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(100),
//                   bottomRight: Radius.circular(20),
//                 ),
//                 child: AppBar(
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   title: Center(
//                     child: Text(
//                       'Home',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   leading: IconButton(
//                     icon: Icon(Icons.menu),
//                     color: Colors.white,
//                     onPressed: () {
//                       // Open side menu
//                     },
//                   ),
//                   actions: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(right: 16.0),
//                       child: IconButton(
//                         icon: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 2.0,
//                             ),
//                           ),
//                           child: CircleAvatar(
//                             backgroundImage:
//                                 AssetImage('assets/images/kitty.png'),
//                           ),
//                         ),
//                         onPressed: () {
//                           // Navigate to profile page
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.all(32.0),
//               child: Text(
//                 '    Welcome to GoodsGuardian',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.italic,
//                   color: Color.fromRGBO(66, 125, 157, 1),
//                   shadows: [
//                     Shadow(
//                       color: Color.fromRGBO(155, 190, 200, 1),
//                       offset: Offset(2, 3),
//                       blurRadius: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Card(
//                         margin: EdgeInsets.all(16),
//                         color: Color.fromRGBO(155, 190, 200, 1),
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red,
//                               ),
//                               width: 30,
//                               height: 35,
//                               margin: EdgeInsets.all(17),
//                               child: Container(
//                                 // Wrapping Image.asset inside a Container
//                                 width: 25,
//                                 height: 35,
//                                 child: Image.asset(
//                                     'assets/images/removedbgIDK.png'),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Employees',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   '2500 ',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Card(
//                         margin: EdgeInsets.all(16),
//                         color: Color.fromRGBO(187, 132, 147, 1),
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red,
//                               ),
//                               width: 30,
//                               height: 35,
//                               margin: EdgeInsets.all(17),
//                               child: Container(
//                                 // Wrapping Image.asset inside a Container
//                                 width: 30,
//                                 height: 40,
//                                 child: Image.asset('assets/images/cold.png'),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Products',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   '50000',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10), // Adding space between the columns
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Card(
//                         margin: EdgeInsets.all(16),
//                         color: Color.fromRGBO(119, 176, 170, 1),
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red,
//                               ),
//                               width: 30,
//                               height: 35,
//                               margin: EdgeInsets.all(17),
//                               child: Container(
//                                 // Wrapping Image.asset inside a Container
//                                 width: 30,
//                                 height: 40,
//                                 child: Image.asset(
//                                     'assets/images/creamRemovebg.png'),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'RFID Tags',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   '565665',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Card(
//                         margin: EdgeInsets.all(16),
//                         color: Color.fromRGBO(219, 175, 160, 1),
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red,
//                               ),
//                               width: 30,
//                               height: 35,
//                               margin: EdgeInsets.all(17),
//                               child: Container(
//                                 // Wrapping Image.asset inside a Container
//                                 width: 30,
//                                 height: 40,
//                                 child: Image.asset('assets/images/drugs.png'),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Branches',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   '2 branches',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Notification.dart';
import 'package:smartinventory/screens/SideBar.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: NavBar(),
      body: Stack(
        children: [
          // Background image and content
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/blurHomePage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: IconButton(
                    //     icon: const Icon(Icons.more_vert, color: Colors.white),
                    //     onPressed: () {
                    //       //
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 7.0),
                const Center(
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                decoration: const BoxDecoration(
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
                              const SizedBox(height: 8),
                              const Text(
                                'Spending',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\$1200',
                                style: TextStyle(
                                  color: Color(0xFF135D66),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              const Text(
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

                  const SizedBox(width: 10.0),

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
                                decoration: const BoxDecoration(
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
                              const SizedBox(height: 8),
                              const Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\$1500',
                                style: TextStyle(
                                  color: Color(0xFF135D66),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              const Text(
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
