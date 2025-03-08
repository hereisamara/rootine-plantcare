
import 'package:rootine/models/plant_card_data.dart';
import 'package:rootine/pages/plant_profile_details.dart';
import 'package:flutter/material.dart';


class PlantProfileCard extends StatelessWidget {
  final PlantCardData plant;
  final String idToken;
  final VoidCallback reload;

  const PlantProfileCard({
    super.key,
    required this.plant,
    required this.idToken,
    required this.reload
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantProfileDetails(plantId: plant.plantId!,idToken: idToken),
          ),
        );
        reload();
      },
      child: Container(
      margin: EdgeInsets.all(10.0),
      width: 200,
      height: 250,
      child: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(plant.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark transparent overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Plant Name
                  Expanded(
                    child: Text(
                      plant.plantName!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Circles
                  Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(plant.reminders?.length ?? 0, (index) {
                          if (plant.reminders![index]) {
                            // Define your colors based on the index or any other logic
                            Color color;
                            switch (index) {
                              case 0:
                                color = Color(0xff9BD885);
                                break;
                              case 1:
                                color = Color(0xffE0AEF2);
                                break;
                              case 2:
                                color = Color(0xffF3C999);
                                break;
                              case 3:
                                color = Color(0xff21A2FF);
                                break;
                              default:
                                color = Colors.black; // Default color
                            }

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // Empty widget when the reminder is false
                          }
                        }),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}