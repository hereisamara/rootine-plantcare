
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rootine/pages/forget_password.dart';
import 'package:rootine/providers/auth_provider.dart';
import 'package:rootine/providers/user_profile_provider.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rootine/pages/FAQ.dart';
import 'package:rootine/pages/home.dart';
import 'package:rootine/pages/login.dart';
import 'package:rootine/pages/camera.dart';
import 'package:rootine/pages/plant_profile_details.dart';
import 'package:rootine/pages/setting.dart';
import 'package:rootine/pages/signup.dart';
import 'package:rootine/pages/user_setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
      ],
      child: const Rootine(),
    ),
  );
}

class Rootine extends StatelessWidget {
  const Rootine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rootine',
      theme: ThemeData(
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white, // Transparent status bar
            statusBarIconBrightness: Brightness.dark, // Dark icons
          ),
        ),

      ),
      initialRoute: Login.routeId,
      routes: {
        Login.routeId: (context) => Login(),
        SignUp.routeId: (context) => SignUp(),
        Home.routeId: (context) =>
            Home(userName: '', idToken: ''), // Provide a default value
        Camera.routeId: (context) => Camera(idToken: ''),
        PlantProfileDetails.routeId: (context) => PlantProfileDetails(
              idToken: '',
              plantId: '',
            ),
        UserSetting.routeId: (context) => UserSetting(),
        ForgetPassword.routeId: (context) => ForgetPassword(),

        SettingPage.routeId: (context) => SettingPage(),
        FAQsPage.routeId: (context) => FAQsPage(),
      },
    );
  }
}
