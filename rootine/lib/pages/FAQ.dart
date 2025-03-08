import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  static final String routeId = 'FAQsPage';
  const FAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('What is Rootine?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Rootine is a mobile application designed to leverage technology to enhance plant health and combat the effects of climate change. It assists users in identifying plant diseases, managing plant care, and contributing to sustainable agriculture practices.'),
            ),
            ListTile(
              title: Text('Who can benefit from using Rootine?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Rootine is ideal for farmers, home gardeners, and community gardeners who face challenges in managing plant health due to changing environmental conditions.'),
            ),
            ListTile(
              title: Text('How do I register and sign in to the app?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Users can register by providing their email address and creating a password. To sign in, enter the registered email and password on the login page.'),
            ),
            ListTile(
              title: Text(
                  'What features does Rootine offer to help manage plant health?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Rootine offers several key features: Plant Disease Identifier allows users to upload images of their plants to diagnose diseases using a machine learning model. Plant Tracker enables users to create profiles for their plants, track growth, and set reminders for essential care activities.'),
            ),
            ListTile(
              title: Text('How does the disease identification feature work?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Users can upload or capture images of their plants. These images are analyzed using a machine learning model trained on datasets like PlantDoc and PlantVillage, which can identify various plant diseases and provide recommendations for treatment.'),
            ),
            ListTile(
              title: Text('How do I add a plant to my Rootine app? ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Go to the Plant Tracker section, click on Add Plant, and enter the necessary details such as plant name, species, and planting date.'),
            ),
            ListTile(
              title: Text('What types of reminders can I set in the app? ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'Users can set reminders for watering, fertilizing, pruning, and pest control based on the specific needs of each plant.'),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
