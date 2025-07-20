import 'package:flutter/material.dart';
import 'converter_screen.dart'; // We'll create this next.

class TempConverterHomeScreen extends StatelessWidget {
  const TempConverterHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TempConverterScreen()),
            );
          },
          child: const Text('Go to Converter'),
        ),
      ),
    );
  }
}
