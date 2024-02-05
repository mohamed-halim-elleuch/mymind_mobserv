import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentScreen extends StatelessWidget {
  final String doctolibUrl = 'https://www.doctolib.fr/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'To take an appointment, please',
                style: TextStyle(
                  fontSize: 24.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
              const Text(
                'visit this website:',
                style: TextStyle(fontSize: 24.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                onTap: () => _launchURL(doctolibUrl),
                child: Text(
                  doctolibUrl,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Add your image here
              Image.asset(
                'assets/doctolib.png', // Replace with your image path
                width: 350.0, // Adjust the width as needed
                height: 230.0, // Adjust the height as needed
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

      await launchUrl(uri);

  }
}