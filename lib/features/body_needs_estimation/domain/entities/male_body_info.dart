
import 'package:ukla_app/features/body_needs_estimation/domain/entities/BodyInfo.dart';

class MaleBodyInfo extends BodyInfo {
  MaleBodyInfo({
     this.id,
     this.physicalActivityLevelF,
     super.height,
     super.weight,  
     super.age,
     super.physicalActivityLevelA,
     super.physicalActivityLevelB,
     super.physicalActivityLevelC,
     super.physicalActivityLevelD,
     super.physicalActivityLevelE,
     super.calorieNeed
  });

  int? id;
  double? physicalActivityLevelF ;
}
