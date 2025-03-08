import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/pages/FAQ.dart';
import 'package:rootine/pages/customer_support.dart';
import 'package:rootine/pages/login.dart';
import 'package:rootine/pages/setting.dart';
import 'package:provider/provider.dart';
import 'package:rootine/models/user_profile_data.dart';
import 'package:rootine/pages/subscribe_page.dart';
import 'package:rootine/providers/user_profile_provider.dart';

class UserSetting extends StatelessWidget {
  static final String routeId = 'userSettingPage';

  UserSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProfile user = Provider.of<UserProfileProvider>(context).userProfile!;

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 60, bottom: 30, left: 30, right: 30),
            color: const Color.fromRGBO(
                117, 160, 129, 1), // Sets the background color to a green shade
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Aligns items centrally in the Column
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.imageUrl ??
                      'https://example.com/default-profile.jpg'), // Your profile image URL
                ),
                SizedBox(
                    height: 10), // Space between the avatar and the username
                Text(
                  user.name ?? 'Unknown User',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ), // Optional: Set text color to white for contrast
                Text(
                  user.email ?? 'No email',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ), // Optional: Set text color to white for contrast
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubscribePage()),
                    );
                  },
                  child: Text('Subscribe to Premium'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        const Color.fromRGBO(117, 160, 129, 1), // Button color
                    backgroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Setting"),
            leading: Icon(Icons.settings),
            onTap: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );

              if (updated == true) {
                // If the profile was updated, refresh the profile data
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final idToken = await user.getIdToken();
                  UserProfileProvider userProfileProvider =
                      Provider.of<UserProfileProvider>(context, listen: false);
                  ApiService apiService = ApiService();
                  UserProfile updatedProfile =
                      await apiService.getUserProfile(context, idToken!);
                  userProfileProvider.updateUserProfile(updatedProfile);
                }
              }
            },
          ),
          ListTile(
            title: Text("Customer Support"),
            leading: Icon(Icons.message),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerSupportPage()),
              );
            },
          ),
          ListTile(
            title: Text("FAQs"),
            leading: Icon(Icons.format_quote_sharp),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQsPage()),
              );
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        Login()), // Replace Login with your login page widget
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
