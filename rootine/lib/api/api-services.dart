import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rootine/models/plant_card_data.dart';
import 'package:rootine/models/plant_detail_data.dart';
import 'package:rootine/models/user_profile_data.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rootine/providers/auth_provider.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = "http://localhost/api"}); // change this to host backend server address

  Future<void> createUserProfile({
    required BuildContext context,
    required String idToken,
    required String name,
    File? photo,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;
    
    var uri = Uri.parse('$baseUrl/create_user_profile');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $idToken';

    request.fields['name'] = name;


    if (photo != null) {
      // Change the file name here
      var newFileName = 'newFileName.jpg'; // Change this to your desired file name
      var stream = http.ByteStream(photo.openRead());
      var length = await photo.length();

      var multipartFile = http.MultipartFile(
        'newplant', // field name
        stream,
        length,
        filename: newFileName,
        contentType: MediaType('image', 'jpeg'), // set appropriate content type
      );

      request.files.add(multipartFile);
    }


    var response = await request.send();

    if (response.statusCode == 201) {
      print('User profile created successfully');
    } else {
      var responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create user profile: $responseBody');
    }
  }

  Future<void> updateUserProfile({
    required BuildContext context,
    required String idToken,
    required String name,
    File? photo,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    var uri = Uri.parse('$baseUrl/update_user_profile');
    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $idToken';

    request.fields['name'] = name;

    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('User profile updated successfully');
    } else {
      var responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update user profile: $responseBody');
    }
  }

  Future<UserProfile> getUserProfile(
    BuildContext context, String idToken) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.get(
      Uri.parse('$baseUrl/get_user_profile'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }
  
  Future<Map<String, dynamic>> processImage(
    BuildContext context, String idToken, String imagePath) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final url = Uri.parse('$baseUrl/process_image'); // Replace with your Flask server URL
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $idToken'
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to process image: $responseBody');
    }
  }
  
  Future<List<PlantCardData>> getIndoorPlants(BuildContext context, String idToken) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.get(
      Uri.parse('$baseUrl/get_indoor_plants'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PlantCardData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load indoor plants');
    }
  }

  Future<List<PlantCardData>> getOutdoorPlants(BuildContext context, String idToken) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.get(
      Uri.parse('$baseUrl/get_outdoor_plants'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PlantCardData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load outdoor plants');
    }
  }

  Future<PlantDetailsData> getPlantById(BuildContext context, String plantId, String idToken) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;
    final response = await http.get(
      Uri.parse('$baseUrl/get_plant/$plantId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return PlantDetailsData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load plants');
    }
  }

  Future<void> deletePlant(BuildContext context, String plantId) async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed

    final response = await http.delete(
      Uri.parse('$baseUrl/delete_plant/$plantId'),
      headers: {
        'Authorization': 'Bearer ${authProvider.idToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      var responseBody = response.body;
      var jsonResponse = json.decode(responseBody);
      throw Exception('Failed to delete plant: ${jsonResponse['error']}');
    }
  }

  Future<void> createPlantProfile({
    required BuildContext context,
    required String idToken,
    required String plantName,
    required String species,
    required String plantingDate,
    required String location,
    String? notes,
    File? photo,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    var uri = Uri.parse('$baseUrl/create_plant_profile');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $idToken'
      ..fields['plant_name'] = plantName
      ..fields['species'] = species
      ..fields['planting_date'] = plantingDate
      ..fields['location'] = location;

    if (notes != null) {
      request.fields['notes'] = notes;
    }

    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }

    var response = await request.send();

    if (response.statusCode != 201) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      throw Exception('Failed to create plant profile: ${jsonResponse['error']}');
    }
  }

  Future<void> editPlantProfile({
    required BuildContext context,
    required String idToken,
    required String plantId,
    required String plantName,
    required String species,
    required String plantingDate,
    required String location,
    String? notes,
    File? photo,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    var uri = Uri.parse('$baseUrl/update_plant_profile/$plantId');
    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $idToken'
      ..fields['plant_name'] = plantName
      ..fields['species'] = species
      ..fields['planting_date'] = plantingDate
      ..fields['location'] = location;

    if (notes != null) {
      request.fields['notes'] = notes;
    }
    
    if (photo != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    }

    var response = await request.send();


    if (response.statusCode != 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      throw Exception('Failed to edit plant profile: ${jsonResponse['error']}');
    }
  }

  Future<void> addTrackedData({
    required BuildContext context,
    required String idToken,
    required String plantId,
    required String date,
    required String height,
    required int branchCount,
    required int leafCount,
    required String floweringStage,
    required String healthStatus,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    var uri = Uri.parse('$baseUrl/addTrackedData/$plantId');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $idToken'
      ..fields['date'] = date
      ..fields['height'] = height + " cm"
      ..fields['branch_count'] = branchCount.toString()
      ..fields['leaf_count'] = leafCount.toString()
      ..fields['flowering_stage'] = floweringStage
      ..fields['health_status'] = healthStatus;

    var response = await request.send();

    if (response.statusCode != 201) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      throw Exception('Failed to add tracked data: ${jsonResponse['error']}');
    }
  }

  Future<Map<String, dynamic>> getTrackedDataToday({
    required BuildContext context,
    required String idToken,
    required String plantId,
    required String date,
  }) async {


    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.post(
      Uri.parse('$baseUrl/getTrackedData/$plantId'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'date': date}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else if (response.statusCode == 404){
      return Map<String, dynamic>();
    }
    else {
      throw Exception('Failed to get tracked data for the date');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTrackedData({
    required BuildContext context,
    required String idToken,
    required String plantId,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;
    final response = await http.get(
      Uri.parse('$baseUrl/getAllTrackedData/$plantId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } 
    else if (response.statusCode == 404){
      return List<Map<String, dynamic>>.from([]);
    }
    else {
      throw Exception('Failed to get all tracked data');
    }
  }

  Future<void> addReminders({
    required BuildContext context,
    required String idToken,
    required List<Map<String, dynamic>> reminders,
  }) async { 

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;
    var url = Uri.parse('$baseUrl/addReminders');
  
    Map<String, String> headers = {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(reminders),
    );
    if (response.statusCode != 201) {
      var responseBody = response.body;
      var jsonResponse = json.decode(responseBody);
      throw Exception('Failed to add reminders: ${jsonResponse['error']}');
    }
  }

  Future<List<Map<String, dynamic>>> getReminders({
    required BuildContext context,
    required String idToken,
    required String plantId,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    String idToken = authProvider.idToken!;

    final response = await http.get(
      Uri.parse('$baseUrl/getReminders/$plantId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> reminders = List<Map<String, dynamic>>.from(json.decode(response.body));
      reminders = reminders.where((reminder) => reminder['frequency'] != 'none').toList();
      return reminders;
    } else {
      throw Exception('Failed to get reminders');
    }
  }

  Future<List<Map<String, dynamic>>> getRemindersDueToday({
    required BuildContext context,
    required String idToken,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.get(
      Uri.parse('$baseUrl/getRemindersDueToday'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to get reminders due today');
    }
  }

  Future<void> updateReminderStatus({
    required BuildContext context,
    required String idToken,
    required String plantId,
    required String reminderType,
  }) async {

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.refreshIdTokenIfNeeded(); // Ensure the token is refreshed
    idToken = authProvider.idToken!;

    final response = await http.put(
      Uri.parse('$baseUrl/updateReminderStatus'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'plant_id': plantId,
        'reminder_type': reminderType,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update reminder status');
    }
  }

}