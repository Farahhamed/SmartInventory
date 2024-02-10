import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ActivityLogUI());
}

class ActivityLogUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Log',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Activity Log')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Add functionality to navigate back
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Adjust horizontal padding as needed
          child: ActivityLog(),
        ),
      ),
    );
  }
}

class ActivityLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Assuming you have 10 activity entries
      itemBuilder: (context, index) {
        // Mock data for demonstration
        bool isEntry = index % 2 == 0; // Alternate between entry and exit
        String activityType = isEntry ? 'Entry' : 'Exit';
        Color dotColor = isEntry ? Colors.orange : Colors.red;
        String employeeName = 'John Doe';
        String employeeRFID = 'RFID123';
        String category = 'Category A';
        String itemRFID = 'RFID456';
        DateTime dateTime = DateTime.now();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline on the left
              Container(
                width: 50.0,
                child: Column(
                  children: [
                    Text(
                      '${dateTime.day}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${DateFormat.MMM().format(dateTime)}',
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              // Vertical line
              Container(
                width: 2.0,
                height: 50.0, // Adjust height according to your UI
                color: Colors.black,
              ),
              SizedBox(width: 10.0),
              // Card-like shape on the right
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activity type
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: isEntry ? Colors.orange : Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          activityType,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Time
                      Row(
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 5.0),
                          Text(
                            '${DateFormat.Hms().format(dateTime)}',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // Category and RFID details
                      Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 5.0),
                          Text(
                            category,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Spacer(),
                          Icon(Icons.confirmation_number),
                          SizedBox(width: 5.0),
                          Text(
                            itemRFID,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      // Employee details
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 5.0),
                          Text(employeeName),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              employeeRFID,
                              style: TextStyle(fontWeight: FontWeight.bold),
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
        );
      },
    );
  }
}
