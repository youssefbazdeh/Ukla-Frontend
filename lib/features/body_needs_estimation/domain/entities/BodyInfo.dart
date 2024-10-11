class BodyInfo {
  BodyInfo(
      {this.height,
      this.weight,
      this.age,
      this.physicalActivityLevelA,
      this.physicalActivityLevelB,
      this.physicalActivityLevelC,
      this.physicalActivityLevelD,
      this.physicalActivityLevelE,
      this.calorieNeed});

  double? height; // in cm
  double? weight; // in kg
  int? age;
  double? physicalActivityLevelA; // number of hours
  double? physicalActivityLevelB; // number of hours
  double? physicalActivityLevelC; // number of hours
  double? physicalActivityLevelD; // number of hours
  double? physicalActivityLevelE; // number of hours
  int? calorieNeed;
}
