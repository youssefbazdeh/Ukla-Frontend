class AppString {
  // static const SERVER_IP = 'https://uklaback.azurewebsites.net';

  static const SERVER_IP = "http://192.168.162.33:8000";
}

// a new extension providing capitalizing a string in dart because in (this version of dart there is not a predifinied method we cas use it )
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
