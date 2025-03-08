class TrackerData {
  String? plantHeight;
  String? branchCounts;
  String? leafCount;
  String? floweringStage;
  String? healthStatus;

  TrackerData({this.plantHeight, this.branchCounts, this.leafCount, this.floweringStage, this.healthStatus});

  void printParameter() {
    print(plantHeight! + branchCounts! + leafCount! + floweringStage! + healthStatus!);
  }
}
