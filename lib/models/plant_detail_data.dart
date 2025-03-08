class PlantDetailsData {
  String? plantId;
  String? plantName;
  String? plantLocationType;
  String? species;
  String? plantAge;
  String? plantDate;
  String? plantNote;
  String? imageUrl;

  PlantDetailsData({
    this.plantId,
    this.plantName,
    this.plantLocationType,
    this.species,
    this.plantAge,
    this.plantDate,
    this.plantNote,
    this.imageUrl,
  });

  factory PlantDetailsData.fromJson(Map<String, dynamic> json) {
    return PlantDetailsData(
      plantId: json['_id'],
      plantName: json['name'],
      plantLocationType: json['location_type'],
      species: json['species'],
      plantAge: json['age'],
      plantDate: json['date'],
      plantNote: json['note'],
      imageUrl: json['image_url'],
    );
  }
}

