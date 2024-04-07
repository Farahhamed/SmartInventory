import 'package:flutter/material.dart';
import 'package:smartinventory/services/PredictService.dart';

//  const PredictScreen({Key? key}) : super(key: key);
class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  //Future<List<String>> predictionResults;

  @override
  // void initState() {
  //   super.initState();
  //   // Call the trainModel method when the screen initializes
  //   _loadPredictionResults();
  // }

  // Method to fetch prediction results from the API
  Future<List<String>> _loadPredictionResults() async {
    try {
      final results = await PredictService.trainModel();
      return results;
    } catch (e) {
      // Handle error
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Prediction Results:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Display the prediction results as a list

            Expanded(
                child: FutureBuilder<List<String>>(
                    future: _loadPredictionResults(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Build ListView using the fetched data
                      return Column(
                        children: [
                          Text('date: ${snapshot.data![0]}'),
                          Text('prediction: ${snapshot.data![1]}')
                        ],
                      );
                      // return ListView.builder(
                      //   itemCount: snapshot.data!.length,
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                      //     print(snapshot.data![index]);
                      //     return ListTile(
                      //       title:
                      //           Text('Result $index: ${snapshot.data![index]}'),
                      //     );
                      //   },
                      // );
                    })),
            // Show a message if no results are available
            // if (predictionResults.isEmpty)
            //   Text(
            //     'No prediction results available.',
            //     style: TextStyle(fontSize: 16),
            //   ),
          ],
        ),
      ),
    );
  }
}
