import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rootine/api/api-services.dart';

Map<String, String> plantCareInstructions = {
  "blight": "Characterized by spots and decay, often in tomatoes and potatoes. Remove affected parts immediately and ensure good air circulation. Use fungicides if necessary.",
  "spot": "Dark spots on leaves or fruits. Improve air circulation, avoid overhead watering, and apply fungicides.",
  "mildew": "White or gray powdery spots on leaves. Increase air circulation, reduce humidity, and use fungicidal sprays.",
  "scab": "Crusty patches on fruits, leaves, or tubers. Practice crop rotation, avoid overhead watering, and use resistant varieties.",
  "yellow virus": "Leaves turning yellow, often caused by a virus transmitted by insects. Control insect pests, remove and destroy infected plants.",
  "rot": "Decaying of plant parts, typically roots or fruits. Ensure well-draining soil, avoid overwatering, and remove affected parts.",
  "mosaic": "Mottled or distorted leaves, often caused by a virus. Remove infected plants, control insect vectors, and avoid handling healthy plants after touching infected ones.",
  "rust": "Orange or brown pustules on leaves or stems. Remove infected parts, avoid water splash on leaves, and apply fungicides.",
  "mold": "Fuzzy growths on leaves or stems, usually white or gray. Improve air circulation, reduce humidity, and clean away debris.",
  "spider mites": "Tiny spider-like pests causing yellow speckles on leaves. Increase humidity, use insecticidal soap, and introduce natural predators like ladybugs.",
  "healthy": "Plant is showing no signs of disease. Continue providing optimal light, water, and nutrients."
};


class PlantDiagnosis extends StatefulWidget {
  final String imagePath;
  final String idToken;

  PlantDiagnosis({required this.imagePath, required this.idToken});

  @override
  _PlantDiagnosisState createState() => _PlantDiagnosisState();
}

class _PlantDiagnosisState extends State<PlantDiagnosis> {
  String diagnosis = "";
  String care = "";
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _processImage(widget.imagePath);
  }

  Future<void> _processImage(String imagePath) async {
    try {
      final response = await apiService.processImage(context, widget.idToken, imagePath);
      String plantClass = response['class'] ?? 'healthy';
      setState(() {
        if(plantClass == 'healthy')
        {
          diagnosis = "Nothing detected!";
          care = "Our model cannot detect anything from your photo.";
        }
        else{
          diagnosis = "$plantClass detected!";
          care = plantCareInstructions[plantClass.toLowerCase()] ?? 'Care instructions not found';
        }
      });
    } catch (e) {
      setState(() {
        diagnosis = 'Failed to process image';
        care = 'Please try again';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant Diagnosis',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: File(widget.imagePath).existsSync()
                ? Image.file(File(widget.imagePath))
                : const Placeholder(
                    fallbackWidth: 200,
                    fallbackHeight: 200,
                  ),
          ),
          Positioned(
            child: Container(
              width: 290,
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 0, 0, 0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 36),
                      width: 246,
                      child: Column(
                        children: <Widget>[
                          Text(
                            diagnosis.isEmpty ? 'Diagnosing...' : diagnosis,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffA6FF86),
                            ),
                          ),
                          Text(
                            care.isEmpty
                                ? 'Please wait while we process the image'
                                : care,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          diagnosis.isNotEmpty
                              ? Text(
                                  'More Instructions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffA6FF86),
                                  ),
                                )
                              : Container(),
                          diagnosis.isNotEmpty
                              ? Text(
                                  care,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 42),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5B7A49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Scan Again',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
