import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ActivityLogUI());
}

class ActivityLogUI extends StatelessWidget {
  const ActivityLogUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Log',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Activity Log')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Add functionality to navigate back
            },
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0), // Adjust horizontal padding as needed
          child: ActivityLog(),
        ),
      ),
    );
  }
}

class ActivityLog extends StatelessWidget {
  const ActivityLog({super.key});

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
              SizedBox(
                width: 50.0,
                child: Column(
                  children: [
                    Text(
                      '${dateTime.day}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.MMM().format(dateTime),
                    ),
                    const SizedBox(height: 5.0),
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
              const SizedBox(width: 10.0),
              // Vertical line
              Container(
                width: 2.0,
                height: 50.0, // Adjust height according to your UI
                color: Colors.black,
              ),
              const SizedBox(width: 10.0),
              // Card-like shape on the right
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activity type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: isEntry ? Colors.orange : Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          activityType,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Time
                      Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 5.0),
                          Text(
                            DateFormat.Hms().format(dateTime),
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // Category and RFID details
                      Row(
                        children: [
                          const Icon(Icons.category),
                          const SizedBox(width: 5.0),
                          Text(
                            category,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const Spacer(),
                          const Icon(Icons.confirmation_number),
                          const SizedBox(width: 5.0),
                          Text(
                            itemRFID,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // Employee details
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 5.0),
                          Text(employeeName),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Text(
                              employeeRFID,
                              style: const TextStyle(fontWeight: FontWeight.bold),
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
