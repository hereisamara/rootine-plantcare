class UserProfile {
  String? id;
  String? email;
  String? name;
  String? imageUrl;

  UserProfile({
    this.id,
    this.email,
    this.name,
    this.imageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      imageUrl: json['profile_url'],
    );
  }
}