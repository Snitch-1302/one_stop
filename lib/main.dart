import 'package:flutter/material.dart';
import 'package:one_stop/decibel_page.dart';
import 'package:one_stop/weather_page.dart';
import 'package:one_stop/traffic_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One Stop'), // Change the title to "One Stop"
        centerTitle: true, // Center the title horizontally
        leading: Container(
        margin: const EdgeInsets.all(8.0),
        child: Image.asset('assets/icon.jpeg'), // Add your app icon here
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DecibelPage()),
                    );
                  },
                  child: const Text('Decibel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WeatherPage()),
                    );
                  },
                  child: const Text('Weather'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrafficPage()),
                    );
                  },
                  child: const Text('Traffic'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
