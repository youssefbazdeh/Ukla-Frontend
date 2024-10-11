import 'dart:convert';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Meal.dart';

PlanApi planApiFromJson(String str) => PlanApi.fromJson(json.decode(str));

List<PlanApi> planApiListFromJson(String str) =>
    List<PlanApi>.from(json.decode(str).map((x) => PlanApi.fromJson(x)));

String planApiToJson(PlanApi data) => json.encode(data.toJson());

class PlanApi {
  PlanApi({
    this.id,
    required this.name,
    required this.days,
    required this.calories,
    this.followed,
  });

  int? id;
  String name;
  List<Day> days;
  double? calories;
  bool? followed;


  factory PlanApi.fromJson(Map<String, dynamic> json) => PlanApi(
        id: json["id"],
        name: json["name"],
        followed: json["followed"],
        calories: json["calories"],
        days: json["days"] != null ? List<Day>.from(json["days"].map((x) => Day.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "followed": followed,
    "calories": calories,
    "days": List<dynamic>.from(days.map((x) => x.toJson())),

      };
}

class Day {
  Day({
    required this.id,
    required this.name,
    this.meals,
    required this.date,
  });

  int id;
  String name;
  DateTime date;
  List<Meal>? meals;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        meals: json["meals"] != null ? List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "date":
    "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "meals": meals != null ? List<dynamic>.from(meals!.map((x) => x.toJson())) : null,
  };
}
