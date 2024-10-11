import 'package:ukla_app/features/body_needs_estimation/domain/entities/BodyInfo.dart';

class FemaleBodyInfo extends BodyInfo {
  FemaleBodyInfo( {
    
  
     super.height,
     super.weight,  
     super.age,
     super.physicalActivityLevelA,
     super.physicalActivityLevelB,
     super.physicalActivityLevelC,
     super.physicalActivityLevelD,
     super.physicalActivityLevelE,
     super.calorieNeed,
    id,
    pregnant,
    pregnancyDate,
  });
  int? id;
  bool? pregnant;
  DateTime? pregnancyDate;
}
