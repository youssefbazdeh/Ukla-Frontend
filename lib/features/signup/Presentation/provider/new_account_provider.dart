import 'package:flutter/material.dart';
import 'package:ukla_app/features/signup/Domain/gender.dart';

class NewAccountProvider extends ChangeNotifier {
  String firstName = "";
  String lastName = "";
  DateTime birthdate = DateTime.now();
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  Gender? gender;

  void setFirstName(String firstname) {
    firstName = firstname;
    notifyListeners();
  }

  void setLastName(String lastname) {
    lastName = lastname;
    notifyListeners();
  }

  void setBirthday(DateTime birthday) {
    birthdate = birthday;
    notifyListeners();
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setConfirmPassword(String resetpassword) {
    confirmPassword = resetpassword;
    notifyListeners();
  }

  void setGender(Gender gender) {
    this.gender = gender;
    notifyListeners();
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getUsername() {
    return username;
  }

  DateTime getbirthdate() {
    return birthdate;
  }

  String getEmail() {
    return email;
  }

  Gender getGender() {
    return gender!;
  }

  String getPassword() {
    return password;
  }

  String getConfirmPassword() {
    return confirmPassword;
  }
}
