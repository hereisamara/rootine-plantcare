import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rootine/api/api-services.dart';
import 'package:intl/intl.dart';


class StatisticsScreen extends StatefulWidget {
  final String idToken;
  final String plantId;
  final String plantNote;
  const StatisticsScreen({super.key, required this.idToken, required this.plantId, required this.plantNote});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Map<String, dynamic>>> futureTrackedData;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureTrackedData = apiService.getAllTrackedData(
      context: context,
      idToken: widget.idToken,
      plantId: widget.plantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Plant Description Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.sticky_note_2_rounded,
                size: 18,
                color: Color(0xff3D3D3D),
              ),
              SizedBox(width: 16),
              Container(
                width: 290,
                child: IntrinsicHeight(
                  child: Text(
                    widget.plantNote,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff5B7A49),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          // Statistics Title
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B7A49),
            ),
          ),
          SizedBox(height: 16),
          // Display Tracked Data
          FutureBuilder<List<Map<String, dynamic>>>(
              future: futureTrackedData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> trackedData = snapshot.data!;
                  if(trackedData.isEmpty){
                    return Center(
                      child: Text("You do not have enough tracked data for your plant yet."));
                  }
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          
                          children: [
                            _buildLineChart(trackedData, 'height', 'Height (cm)'),
                            _buildLineChart(trackedData, 'branch_count', 'Branch Count'),
                            _buildLineChart(trackedData, 'leaf_count', 'Leaf Count'),
                            // Flowering stage and health status are categorical and may need a different visualization approach
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No tracked data available'));
                }
              },
            ),
        ],
      ),
    );
  }
  Widget _buildLineChart(List<Map<String, dynamic>> trackedData, String key, String title) {
    List<FlSpot> spots = _generateSpots(trackedData, key);
    List<DateTime> dates = trackedData.map((data) => DateTime.parse(data['date'])).toList();

    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff5B7A49),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false, )),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Show titles at each x-axis value
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= dates.length) {
                          return Container();
                        }
                        DateTime date = dates[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date), // Format date as 'MM/dd'
                            style: TextStyle(
                              fontSize: 10, // Adjust the font size here
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 10, // Adjust the font size here
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Color(0xff5B7A49), width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots(List<Map<String, dynamic>> trackedData, String key) {
    List<FlSpot> spots = [];
    for (int i = 0; i < trackedData.length; i++) {
      double value = double.tryParse(trackedData[i][key].toString().split(' ')[0]) ?? 0;
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

}
