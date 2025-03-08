import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/components/tracker/plant_tracker.dart';
import 'package:rootine/components/tracker/plant_tracker_update.dart';

class TrackerScreen extends StatefulWidget {
  final String idToken;
  final String plantId;

  const TrackerScreen({super.key, required this.idToken, required this.plantId});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late bool isInUpdateMode;
  Future<Map<String, dynamic>>? futureTrackedDataToday;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    isInUpdateMode = false;
    futureTrackedDataToday = fetchTrackedDataToday();
  }

  Future<Map<String, dynamic>> fetchTrackedDataToday() async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var data = await apiService.getTrackedDataToday(
      context: context,
      idToken: widget.idToken,
      plantId: widget.plantId,
      date: todayDate,
    );
    return data;
  }

  void _reloadTrackerData() {
    setState(() {
      futureTrackedDataToday = fetchTrackedDataToday();
      isInUpdateMode = false;
    });
  }
  void _cancelUpdate() {
    setState(() {
      isInUpdateMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: FutureBuilder<Map<String, dynamic>>(
        future: futureTrackedDataToday,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> trackedDataToday = snapshot.data!;
            return Column(
              children: [
                // Plant tracker page or Plant tracker edit page
                isInUpdateMode
                    ? PlantTrackerUpdate(
                        idToken: widget.idToken,
                        plantId: widget.plantId,
                        onTrackedDataUpdated: _reloadTrackerData,
                        onCancel: _cancelUpdate
                      )
                    : PlantTracker(
                        idToken: widget.idToken,
                        plantId: widget.plantId,
                        trackedDataToday: trackedDataToday.isEmpty ? null: trackedDataToday,
                      ),
                // Update button displayed or not according to isInUpdateMode state
                isInUpdateMode
                    ? Container()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff75A081),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              setState(() {
                                isInUpdateMode = !isInUpdateMode;
                              });
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
