import 'package:flutter/material.dart';

class SubscribePage extends StatelessWidget {
  static final String routeId = 'SubscribePage';
  const SubscribePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe to Premium'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset(
                'assets/images/rootinelogo.png'), // Ensure you have an image in the assets
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Button was pressed!');
              },
              child: Text('300 Baht / Month'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF75A081),
                foregroundColor:
                    Colors.white, // Setting the button color to #75A081
              ),
            ),
            SizedBox(height: 16),
            Image.asset(
                'assets/images/rootinelogo.png'), // Ensure you have an image in the assets
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Button was pressed!');
              },
              child: Text('3000 Baht / Year'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF75A081),
                foregroundColor:
                    Colors.white, // Setting the button color to #75A081
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Premium subscription offering unlimited access to plant profile and advanced features',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
