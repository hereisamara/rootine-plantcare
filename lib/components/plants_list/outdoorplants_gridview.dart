import 'package:flutter/material.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/components/plants_list/PlantProfileCard.dart';
import 'package:rootine/models/plant_card_data.dart';

class OutdoorPlantsGridView extends StatefulWidget {
  final String idToken;
  const OutdoorPlantsGridView({super.key, required this.idToken});

  @override
  State<OutdoorPlantsGridView> createState() => _OutdoorPlantsGridViewState();
}

class _OutdoorPlantsGridViewState extends State<OutdoorPlantsGridView> {
  late Future<List<PlantCardData>> futurePlants;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePlants = apiService.getOutdoorPlants(context, widget.idToken);
  }

  void _reload(){
    setState(() {
      futurePlants = apiService.getIndoorPlants(context, widget.idToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantCardData>>(
      future: futurePlants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<PlantCardData>? plants = snapshot.data;
          if (plants != null && plants.isEmpty){
            return const Center(child: Text('You don\'t have any outdoor plants right now.'));
          }

          return GridView.builder(
            itemCount: plants!.length,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 95 / 120),
            itemBuilder: (context, index) {
              return PlantProfileCard(
                plant: plants[index],
                idToken: widget.idToken,
                reload: _reload
              );
            },
          );
        } else {
          return const Center(child: Text('No plants available'));
        }
      },
    );
  }
}

