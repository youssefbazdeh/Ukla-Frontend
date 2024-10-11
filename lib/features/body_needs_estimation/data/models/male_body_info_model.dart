import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';

class MaleBodyInfoModel extends MaleBodyInfo {
  MaleBodyInfoModel(
      {super.id,
      super.height,
      super.weight,
      super.age,
      super.physicalActivityLevelA,
      super.physicalActivityLevelB,
      super.physicalActivityLevelC,
      super.physicalActivityLevelD,
      super.physicalActivityLevelE,
      super.physicalActivityLevelF,
      super.calorieNeed});

  factory MaleBodyInfoModel.fromJson(Map<String, dynamic> json) =>
      MaleBodyInfoModel(
        height: json["height"]!,
        weight: json["weight"]!,
        age: json["age"],
        physicalActivityLevelA: json["physicalActivityLevelA"],
        physicalActivityLevelB: json["physicalActivityLevelB"],
        physicalActivityLevelC: json["physicalActivityLevelC"],
        physicalActivityLevelD: json["physicalActivityLevelD"],
        physicalActivityLevelE: json["physicalActivityLevelE"],
        calorieNeed: json["calorieNeed"],
        id: json["id"]!,
        physicalActivityLevelF: json["physicalActivityLevelF"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "age": age,
        "physicalActivityLevelA": physicalActivityLevelA,
        "physicalActivityLevelB": physicalActivityLevelB,
        "physicalActivityLevelC": physicalActivityLevelC,
        "physicalActivityLevelD": physicalActivityLevelD,
        "physicalActivityLevelE": physicalActivityLevelE,
        "calorieNeed": calorieNeed,
        "id": id,
        "physicalActivityLevelF": physicalActivityLevelF,
      };
}
