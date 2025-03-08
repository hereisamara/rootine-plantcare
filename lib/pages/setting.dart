import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootine/api/api-services.dart';

class SettingPage extends StatelessWidget {
  static final String routeId = 'SettingPage';

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color.fromRGBO(117, 160, 129, 1),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(117, 160, 129, 1),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                UpdateProfileForm(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateProfileForm extends StatefulWidget {
  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  File? image;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      nameController.text = '';
      profileImageUrl = 'https://example.com/profile.jpg';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Resize the image
      final imageBytes = await pickedFile.readAsBytes();
      img.Image originalImage = img.decodeImage(imageBytes)!;
      img.Image resizedImage = img.copyResize(originalImage, width: 300); // Resize to 300px width

      // Save the resized image to a temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final tempPath = '${tempDir.path}/resized_image.jpg';
      final resizedFile = File(tempPath);
      resizedFile.writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

      setState(() {
        image = resizedFile;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final idToken = await user.getIdToken();
          await ApiService().updateUserProfile(
            context: context,
            idToken: idToken!,
            name: nameController.text,
            photo: image,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User profile updated successfully')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Update Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : NetworkImage(profileImageUrl ?? 'https://example.com/profile.jpg')
                          as ImageProvider,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:  BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Profile Photo", style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 20),
              buildTextFormField("Name", nameController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateUserProfile,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(117, 160, 129, 1),
                  ),
                ),
              ),
            ],),
          )
          
        ],
      ),
    );
  }

  TextFormField buildTextFormField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
