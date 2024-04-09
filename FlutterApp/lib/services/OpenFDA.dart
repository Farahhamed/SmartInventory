// Import necessary Dart packages.
import 'dart:convert';
import 'package:http/http.dart' as http;
/*import 'package:openfda_adverse_events_flutter/openfda_adverse_events_flutter.dart';*/

// Define the Event class to model the data structure from the API.
class Event {
  // Define properties based on the JSON structure.
  final String originalReceiveDate;
  final List<Reaction> reactions;
  // ... include other relevant fields

  Event({required this.originalReceiveDate, required this.reactions});

  // A factory constructor for creating an instance from a JSON object.
  factory Event.fromJson(Map<String, dynamic> json) {
    var list = json['reaction'] as List;
    List<Reaction> reactionList =
        list.map((i) => Reaction.fromJson(i)).toList();
    return Event(
      originalReceiveDate: json['original_receive_date'],
      reactions: reactionList,
    );
  }
}

// Define the Reaction class.
class Reaction {
  final String veddraTermName;
  // ... include other relevant fields

  Reaction({required this.veddraTermName});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      veddraTermName: json['veddra_term_name'],
    );
  }
}

// Create a service class to handle API interactions.
class OpenFDAApiService {
  // Define the base URL of the openFDA API.
  final String _baseUrl = 'https://api.fda.gov/animalandveterinary/event.json';

  // Method to fetch adverse events.
  Future<List<Event>> fetchAdverseEvents({required String query}) async {
    try {
      // Construct the URL with the provided query.
      final response = await http.get(Uri.parse('$_baseUrl?search=$query'));

      // Check for a successful response.
      if (response.statusCode == 200) {
        // Parse the JSON response.
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> results = json['results'];

        // Convert the JSON to a list of Event objects.
        return results.map((eventJson) => Event.fromJson(eventJson)).toList();
      } else {
        // Handle the case where the server did not return a 200 OK response.
        throw Exception('Failed to load adverse events');
      }
    } catch (e) {
      // Handle any exceptions thrown during the API call.
      throw Exception('Error fetching data: $e');
    }
  }

// TODO: Implement additional methods as necessary.
}

void main() {
  // Example usage of the OpenFDAApiService.
  OpenFDAApiService apiService = OpenFDAApiService();

  // TODO: Replace with your actual query.
  String exampleQuery = 'original_receive_date:[20040101+TO+20161107]&limit=1';

  apiService.fetchAdverseEvents(query: exampleQuery).then((events) {
    // Process the fetched events.
    // TODO: Implement your logic to handle the events data.
    print('Fetched ${events.length} events');
  }).catchError((error) {
    // Handle any errors here.
    print('Error fetching events: $error');
  });
}
