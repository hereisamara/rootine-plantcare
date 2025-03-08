import 'package:flutter/material.dart';
import 'package:rootine/components/Statistics/statistics_screen.dart';
import 'package:rootine/components/tracker/tracker_screen.dart';
import 'package:rootine/models/plant_detail_data.dart';
import 'package:rootine/pages/edit_plant_profile.dart';
import 'package:rootine/api/api-services.dart';

import '../components/reminder/reminders.dart';

class PlantProfileDetails extends StatefulWidget {
  static final String routeId = 'plantProfileDetails';
  final String idToken;
  final String plantId;

  const PlantProfileDetails(
      {super.key, required this.plantId, required this.idToken});

  @override
  State<PlantProfileDetails> createState() => _PlantProfileDetailsState();
}

class _PlantProfileDetailsState extends State<PlantProfileDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<PlantDetailsData> futurePlant;
  final apiService = ApiService();
  bool hasRemindersForToday = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    futurePlant = apiService.getPlantById(context, widget.plantId, widget.idToken);
    _checkRemindersForToday();
  }

    Future<void> _checkRemindersForToday() async {
    try {
      List<Map<String, dynamic>> reminders = await apiService.getReminders(context: context, plantId: widget.plantId, idToken: widget.idToken);
      if (reminders.isNotEmpty) {
        bool allComplete = reminders.every((reminder) => reminder['status'] == 'complete');
        if(!allComplete){
          setState(() {
            hasRemindersForToday = true;
          });
        }
        else{
          setState(() {
              hasRemindersForToday = false;
            });
        }
      }
      else{
        setState(() {
            hasRemindersForToday = false;
          });
      }
      
    } catch (e) {
      print('Error checking reminders: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(),
      body: FutureBuilder<PlantDetailsData>(
        future: futurePlant,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('This plant profile cannot be loaded.'));
          } else if (snapshot.hasData) {
            PlantDetailsData plant = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 1000,
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 260,
                          child: Image.network(
                            plant.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: double.infinity,
                            height: 81,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(100, 0, 0, 0)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        plant.plantName!,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPlantProfile(
                                                        idToken: widget.idToken,
                                                        plant: plant)),
                                          ).then((value) => setState(() {
                                                futurePlant =
                                                    apiService.getPlantById(
                                                        context,
                                                        widget.plantId,
                                                        widget.idToken);
                                              }));
                                        },
                                        icon: Icon(
                                          Icons.edit_note_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Text(
                                            plant.plantLocationType ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffBEE1A9),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.local_florist_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Text(
                                            plant.species ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffBEE1A9),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Text(
                                            '${plant.plantAge} days old',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xffBEE1A9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Color(0xff75A081),
                      ),
                      child: TabBar(
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        controller: _tabController,
                        tabs: <Widget>[
                          Tab(
                            text: 'Detail',
                          ),
                          Tab(
                            text: 'Tracker',
                          ),
                          Tab(
                            child: Row(
                              children: [
                                Text('Reminder'),
                                if (hasRemindersForToday)
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 95, 235, 14),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          StatisticsScreen(idToken: widget.idToken, plantId: widget.plantId, plantNote: plant.plantNote!,),
                          TrackerScreen(idToken: widget.idToken, plantId: widget.plantId,),
                          Reminder(idToken: widget.idToken, plantId: widget.plantId, noti: _checkRemindersForToday),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No plant data available'));
          }
        },
      ),
    );
  }
}
