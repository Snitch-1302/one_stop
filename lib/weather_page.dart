import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart'; 

const String OPENWEATHERMAP_API_KEY = 'cdd4e27345efccdd3e38500299e2b009'; 

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Page'),
      ),
      body: const WeatherDisplay(),
    );
  }
}

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({Key? key});

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  String? weatherDescription;
  double? temperature;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchWeather();
  }

  void _getLocationAndFetchWeather() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      fetchWeatherData(latitude, longitude);
    } else {
      print('Location permission denied');
    }
  }

  void fetchWeatherData(double latitude, double longitude) async {
    final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$OPENWEATHERMAP_API_KEY&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          weatherDescription = jsonData['weather'][0]['description'];
          temperature = jsonData['main']['temp'];
        });
      } else {
        print('Failed to fetch weather data');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  String determineWeatherCondition(double temperature) {
    if (temperature < 20) {
      return 'Cool';
    } else if (temperature >= 20 && temperature <= 30) {
      return 'Outcast';
    } else {
      return 'Sunny';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/weather.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (weatherDescription != null && temperature != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    Text(
                      'Weather: $weatherDescription',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Temperature: $temperature°C',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Condition: ${determineWeatherCondition(temperature!)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: _getLocationAndFetchWeather,
              child: const Text('Refresh Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
