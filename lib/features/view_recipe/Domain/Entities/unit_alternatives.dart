class UnitAlternative{
  UnitAlternative({
    required this.id,
    required this.conversionRate,
    required this.unit,
  });
  int id;
  double conversionRate;
  String unit;

  factory UnitAlternative.fromJson(Map<String, dynamic> json) => UnitAlternative(
      id: json["id"],
      conversionRate: json["conversionRate"],
      unit: json["unit"]
      );
}