import 'package:flutter/material.dart';
import 'package:rootine/pages/camera.dart';
import 'package:rootine/pages/plant_profiles.dart';
import 'package:rootine/pages/user_setting.dart';

class Home extends StatefulWidget {
  static final String routeId = 'homePage';
  final String userName;
  final String idToken;

  const Home({super.key, required this.userName, required this.idToken});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int selectedIndex;
  late List<Widget> screenList;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    screenList = [
      PlantProfiles(idToken: widget.idToken),
      Camera(
        idToken: widget.idToken,
      ),
      UserSetting(),
    ];
  }

  void onTapItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: screenList[selectedIndex],
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          width: double.infinity,
          height: 76,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onTapItem,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              backgroundColor: Color(0xff75A081),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/sprout.png',
                    color: Colors.white,
                    width: 32,
                    height: 28,
                  ),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/camera1.png',
                      color: Colors.white,
                      width: 32,
                      height: 28,
                    ),
                    label: 'plantDiagnosis'),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/user.png',
                    color: Colors.white,
                    width: 32,
                    height: 28,
                  ),
                  label: 'userSetting',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
