import 'package:flutter/material.dart';

class PlantTracker extends StatefulWidget {
  final String idToken;
  final String plantId;
  final Map<String, dynamic>? trackedDataToday;

  PlantTracker({
    super.key,
    required this.idToken,
    required this.plantId,
    this.trackedDataToday,
  });

  @override
  State<PlantTracker> createState() => _PlantTrackerState();
}

class _PlantTrackerState extends State<PlantTracker> {
  late String plantHeight;
  late String branches;
  late String leaves;
  late String floweringStage;
  late String healthStatus;

  @override
  void initState() {
    super.initState();
    plantHeight = widget.trackedDataToday?['height'] ?? '0';
    branches = widget.trackedDataToday?['branch_count'] ?? '0';
    leaves = widget.trackedDataToday?['leaf_count'] ?? '0';
    floweringStage = widget.trackedDataToday?['flowering_stage'] ?? 'Budding';
    healthStatus = widget.trackedDataToday?['health_status'] ?? 'Healthy';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff5B7A49)),
              ),
              Container(
                width: 250,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, bottom: 3),
                  child: Text(
                    'Ready to update your plant growth for today?',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xff74705F)),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          widget.trackedDataToday != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Tracked Data",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TrackerType(trackerTypeName: 'Height', plantCondition: plantHeight),
                    SizedBox(height: 24),
                    TrackerType(trackerTypeName: 'Branch Count', plantCondition: branches),
                    SizedBox(height: 24),
                    TrackerType(trackerTypeName: 'Leaf Count', plantCondition: leaves),
                    SizedBox(height: 24),
                    TrackerType(trackerTypeName: 'Flowering Stage', plantCondition: floweringStage),
                    SizedBox(height: 24),
                    TrackerType(trackerTypeName: 'Health Status', plantCondition: healthStatus),
                  ],
                )
              : Text("You haven't added any new data for today."),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class TrackerType extends StatelessWidget {
  final String trackerTypeName;
  final String plantCondition;
  const TrackerType({
    super.key,
    required this.trackerTypeName,
    required this.plantCondition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            child: Text(
              trackerTypeName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xff5B7A49),
              ),
            ),
          ),
          SizedBox(width: 52),
          Expanded(
            child: Container(
              child: Text(plantCondition),
            ),
          ),
        ],
      ),
    );
  }
}
