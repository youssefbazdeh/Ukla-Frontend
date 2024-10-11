class Profile{
  Profile({
    required this.id,
    required this.onBoardingScreen
  });
  int id;
  bool onBoardingScreen;
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id : json['id'],
    onBoardingScreen: json["onBoardingScreen"],
  );
  Map<String,dynamic> toJson() => {
    "id": id,
    "onBoardingScreen": onBoardingScreen,
  };
}