import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class DecibelPage extends StatefulWidget {
  const DecibelPage({super.key});

  @override
  State<DecibelPage> createState() => _DecibelPageState();
}

class _DecibelPageState extends State<DecibelPage> {
  Record myRecording = Record();
  Timer? timer;

  double volume = 0.0;
  double minVolume = -45.0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  startTimer() async {
    timer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) => updateVolume());
  }

  updateVolume() async {
    Amplitude amp = await myRecording.getAmplitude();
    if (amp.current > minVolume) {
      setState(() {
        volume = (amp.current - minVolume) / minVolume;
      });
      print("VOLUME: $volume");
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  Future<void> startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      if (!await myRecording.isRecording()) {
        await myRecording.start();
      }
      startTimer();
    } else {
      // Permission denied
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text("This app requires microphone permission to measure decibels."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decibel Measurement'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/decibel.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  startRecording();
                },
                child: const Text('Measure Decibel'),
              ),
              const SizedBox(height: 20),
              Container( // or any widget you prefer
                color: Colors.black.withOpacity(0.5), // background color
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Volume: ${volume0to(100)}',
                  style: const TextStyle(
                    color: Colors.white, // text color
                    fontSize: 24,
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
