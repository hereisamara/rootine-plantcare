import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rootine/api/api-services.dart';
import 'package:image/image.dart' as img;

import '../components/profile_create_update_components/image_uploader.dart';
import '../widget_styles.dart';

class CreatePlantProfile extends StatefulWidget {
  final String idToken;
  const CreatePlantProfile({super.key, required this.idToken});

  @override
  State<CreatePlantProfile> createState() => _CreatePlantProfileState();
}

class _CreatePlantProfileState extends State<CreatePlantProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _speciesController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  File? image;
  String? nameValue;
  String? locationValue;
  String? speciesValue;
  String? plantAge;
  String? noteValue;

  final List<String> locations = ['indoor', 'outdoor'];

  // Define a DateTime variable to store the selected date
  DateTime _selectedDate = DateTime.now();

  // Create a function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _ageController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _ageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  
  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Resize the image
      final imageBytes = await pickedFile.readAsBytes();
      img.Image originalImage = img.decodeImage(imageBytes)!;
      img.Image resizedImage = img.copyResize(originalImage, width: 300); // Resize to 300px width

      // Save the resized image to a temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final tempPath = '${tempDir.path}/resized.jpg';
      final resizedFile = File(tempPath);
      resizedFile.writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

      setState(() {
        image = resizedFile;
      });
    }
  }

  Future<void> _createPlantProfile() async {
    nameValue = _nameController.text;
    speciesValue = _speciesController.text;
    plantAge = _ageController.text;
    noteValue = _noteController.text;

    // print('Image: $image');
    // print('Name: $nameValue');
    // print('Location: $locationValue');
    // print('Species: $speciesValue');
    // print('Plant Age: $plantAge');
    // print('Notes: $noteValue');

    ApiService apiService = ApiService();
    try {
      await apiService.createPlantProfile(
        context:  context,
        idToken: widget.idToken,
        plantName: nameValue!,
        species: speciesValue!,
        plantingDate: plantAge!,
        location: locationValue!,
        notes: noteValue,
        photo: image,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plant profile created successfully')));

      // Navigate back to the plant detail page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: <Widget>[
                // ImageUploading Section
                ImageUploader(
                  imageDefaultPath: 'assets/images/default_image.png',
                  selectedImage: image,
                  pickedImage: getImage,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text(
                            'Create Plant Profile',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5B7A49)),
                          ),
                        ),
                        Container(
                        width: double.infinity,
                        height: 350,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 19,
                          ),
                          children: [
                            //Name
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.keyboard_alt_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff436132)),
                                  )
                                ],
                              ),
                              trailing: Container(
                                width: 170,
                                height: 30,
                                padding: EdgeInsets.all(3),
                                decoration: kTrackerTextFormBoxDecoration,
                                child: TextField(
                                  style: kDetailTextFieldTextStyle,
                                  showCursor: true,
                                  decoration: kTrackerTextFormFieldDecoration,
                                  controller: _nameController,
                                  onChanged: (String newValue) {
                                    nameValue = newValue;
                                  },
                                ),
                              ),
                            ),
                            //Plant Location Type
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff436132)),
                                  )
                                ],
                              ),
                              trailing: Container(
                                width: 170,
                                height: 30,
                                padding: EdgeInsets.all(3),
                                decoration: kTrackerTextFormBoxDecoration,
                                child: Center(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    items: locations.map((String location) {
                                      return DropdownMenuItem(
                                          value: location,
                                          child: Text(location));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        locationValue = newValue;
                                      });
                                    },
                                    value: locationValue,
                                    icon: kRootineDropdownIcon,
                                    borderRadius:
                                        kRootineDropdownButtonBorderRadius,
                                    style: kRootineDropDownButtonTextStyle,
                                    underline: Container(),
                                  ),
                                ),
                              ),
                            ),
                            //Species
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.eco_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Species',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff436132)),
                                  )
                                ],
                              ),
                              trailing: Container(
                                width: 170,
                                height: 30,
                                padding: EdgeInsets.all(3),
                                decoration:kTrackerTextFormBoxDecoration,
                                child: TextField(
                                  style: kDetailTextFieldTextStyle,
                                  showCursor: true,
                                  decoration: kTrackerTextFormFieldDecoration,
                                  controller: _speciesController,
                                  onChanged: (String newValue) {
                                    speciesValue = newValue;
                                  },
                                ),
                              ),
                            ),
                            //Planting Date
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Planting Date',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff436132)),
                                  )
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  width: 170,
                                  height: 30,
                                  padding: EdgeInsets.all(3),
                                  decoration: kTrackerTextFormBoxDecoration,
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      style: kDetailTextFieldTextStyle,
                                      decoration:
                                          kDetailTextFieldDecoration.copyWith(
                                        hintText: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      ),
                                      controller: _ageController,
                                      onChanged: (String newValue) {
                                        plantAge = newValue;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Plant note
                            ListTile(
                              titleAlignment: ListTileTitleAlignment.top,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.sticky_note_2_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Note',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff436132)),
                                  )
                                ],
                              ),
                              trailing: Container(
                                width: 170,
                                padding: EdgeInsets.all(3),
                                decoration: kTrackerTextFormBoxDecoration,
                                child: TextField(
                                  maxLines: 10,
                                  minLines: 5,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  showCursor: false,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      hintText:
                                          'Add some note to your plant profile',
                                      hintStyle:
                                          TextStyle(color: Color(0xffA4A4A4)),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide.none,
                                      )),
                                  controller: _noteController,
                                  onChanged: (String newValue) {
                                    noteValue = newValue;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff75A081),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _createPlantProfile,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
