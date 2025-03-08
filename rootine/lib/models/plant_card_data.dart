class PlantCardData {
  String? plantId;
  String? plantName;
  String? imageUrl;
  List<bool>? reminders;

  PlantCardData({this.plantId, this.plantName, this.imageUrl, this.reminders});

  factory PlantCardData.fromJson(Map<String, dynamic> json) {
    // json {name: "", imageurl: "", reminders: [t,t,t,t]}
    return PlantCardData(
      plantId: json['_id'],
      plantName: json['name'],
      imageUrl: json['image_url'],
      reminders: json['reminders'] != null
          ? List<bool>.from(json['reminders'])
          : null,
    );
  }

  @override
  String toString(){
    String s = reminders.toString();
    return "plant id: $plantId, plant name: $plantName, reminders: $s";
  }
}
