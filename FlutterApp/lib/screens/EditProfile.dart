import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 65, 110),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: -50,
                          right: -50,
                          bottom: 0,
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(150),
                                        topLeft: Radius.circular(250),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(150),
                                        topRight: Radius.circular(250),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.15 - 100,
                          left: MediaQuery.of(context).size.width * 0.5 - 50,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 251, 250, 250),
                                      width: 5),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage('assets/images/kitty.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 5,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border.all(
                                        color: Color.fromARGB(255, 16, 1, 101),
                                        width: 2),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // edit functionality here
                                      },
                                      color: Color.fromARGB(255, 16, 1, 101),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.15,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'First Name',
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Add space between text fields
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Last Name',
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.0,
                                            child: Radio(
                                              value: 'male',
                                              groupValue: '',
                                              onChanged: (value) {},
                                              activeColor: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            'Male',
                                            style: TextStyle(
                                              fontSize:
                                                  16, // Increase the font size
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Transform.scale(
                                            scale: 1.0,
                                            child: Radio(
                                              value: 'female',
                                              groupValue: '',
                                              onChanged: (value) {},
                                              activeColor: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            'Female',
                                            style: TextStyle(
                                              fontSize:
                                                  16, // Increase the font size
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        20), // Add space between radio buttons and text fields
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Bio',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  maxLines: 3, // Make the text field bigger
                                ),
                                SizedBox(
                                    height:
                                        20), // Add space between text fields
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Address',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        20), // Add space between text fields
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // Save functionality here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // Cancel functionality here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }
}
