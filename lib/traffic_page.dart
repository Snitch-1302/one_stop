import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrafficPage extends StatefulWidget {
  const TrafficPage({Key? key});

  @override
  _TrafficPageState createState() => _TrafficPageState();
}

class _TrafficPageState extends State<TrafficPage> {
  late TextEditingController _sourceController;
  late TextEditingController _destinationController;
  String _routeInstructions = '';

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController();
    _destinationController = TextEditingController();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _getRouteInstructions() async {
    String source = _sourceController.text;
    String destination = _destinationController.text;
    String apiKey = ""; // Replace with your Google Maps API key
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$source&destination=$destination&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          List<dynamic> legs = routes[0]['legs'];
          if (legs.isNotEmpty) {
            List<dynamic> steps = legs[0]['steps'];
            String instructions = '';
            for (var step in steps) {
              instructions += '${step['html_instructions']}\n';
            }
            setState(() {
              _routeInstructions = instructions;
            });
            return;
          }
        }
      }
    }
    setState(() {
      _routeInstructions = 'Failed to fetch route instructions.';
    });
  }

  String _parseHtmlInstructions(String htmlInstructions) {
  // Remove HTML tags from the instructions
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlInstructions.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/traffic.jpg'), // Path to your traffic.jpg image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _sourceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Source',
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    hintText: 'Enter Source',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _destinationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    hintText: 'Enter Destination',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getRouteInstructions,
                child: const Text('Get Route Instructions'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _routeInstructions,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
