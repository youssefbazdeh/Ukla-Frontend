enum Gender { Male, Female, Other }

extension GenderExtension on Gender {
  static Gender fromString(String genderString) {
    switch (genderString) {
      case 'Male':
        return Gender.Male;
      case 'Female':
        return Gender.Female;
      case 'Other':
        return Gender.Other;
      default:
        throw Exception('Invalid gender string');
    }
  }

  String toJson() {
    return toString().split('.').last;
  }
}
