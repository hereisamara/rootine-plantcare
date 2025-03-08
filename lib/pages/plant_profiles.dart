import 'package:flutter/material.dart';
import 'package:rootine/components/ad_carousel_slider/carousel_view.dart';
import 'package:rootine/components/plants_list/indoorplants_gridview.dart';
import 'package:rootine/components/plants_list/outdoorplants_gridview.dart';
import 'package:rootine/pages/create_plant_profile.dart';

class PlantProfiles extends StatefulWidget {
  static const String id = 'plantProfiles';
  final String idToken;

  const PlantProfiles({super.key, required this.idToken});

  @override
  State<PlantProfiles> createState() => _PlantProfilesState();
}

class _PlantProfilesState extends State<PlantProfiles> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffF8F8F8),
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 150,
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/headerlogo1.png',
                            width: 36,
                            height: 24,
                          ),
                        ),
                        Text(
                          'Rootine',
                          style: TextStyle(
                            fontFamily: 'Grandstander',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'assets/images/headerlogo2.png',
                            width: 36,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CarouselViewer(),
            SizedBox(
              height: 24,
            ),
            Container(
              width: 350,
              height: 32,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xffF8F8F8),
              ),
              child: TabBar(
                labelStyle: TextStyle(color: Colors.white),
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Color(0xff75A081),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                dividerColor: Colors.transparent,
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Tab(
                      text: 'Indoor Plants',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Tab(
                      text: 'Outdoor Plants',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  IndoorPlantsGridView(
                    idToken: widget.idToken,
                  ),
                  OutdoorPlantsGridView(
                    idToken: widget.idToken,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlantProfile(idToken: widget.idToken)
                ),
            );

            setState(() {
            });

        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 42,
          shadows: [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              spreadRadius: 7,
              blurRadius: 7,
              offset: Offset(2, 2),
            )
          ],
          color: Color(0xff5B7A49),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
