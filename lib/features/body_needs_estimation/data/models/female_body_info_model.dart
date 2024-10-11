
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';

class FemaleBodyInfoModel extends FemaleBodyInfo {
  FemaleBodyInfoModel(
      { super.id,
       super.height,
       super.weight,
       super.age,
       super.physicalActivityLevelA,
       super.physicalActivityLevelB,
       super.physicalActivityLevelC,
       super.physicalActivityLevelD,
       super.physicalActivityLevelE,
       super.pregnancyDate,
       super.pregnant,
       super.calorieNeed});

  factory FemaleBodyInfoModel.fromJson(Map<String, dynamic> json) =>
      FemaleBodyInfoModel(
        height: json["height"]!,
        weight: json["weight"]!,
        age: json["age"],
        physicalActivityLevelA: json["physicalActivityLevelA"],
        physicalActivityLevelB: json["physicalActivityLevelB"],
        physicalActivityLevelC: json["physicalActivityLevelC"],
        physicalActivityLevelD: json["physicalActivityLevelD"],
        physicalActivityLevelE: json["physicalActivityLevelE"],
        calorieNeed: json["calorieNeed"],
        id: json["id"],
        pregnant: json["pregnant"],
        pregnancyDate: json["pregnancyDate"], 
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
        "pregnant" : pregnant,
        "pregnancyDate" : pregnancyDate
     
      };
}
