import 'package:flutter/material.dart';
import 'package:rootine/models/user_profile_data.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? userProfile;

  void setUserProfile(UserProfile profile) {
    userProfile = profile;
    notifyListeners();
  }

  void updateUserProfile(UserProfile profile) {
    userProfile = profile;
    notifyListeners();
  }
}
