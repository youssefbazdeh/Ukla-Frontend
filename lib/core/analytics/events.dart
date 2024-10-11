import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';

class FireBaseAnalyticsEvents {

  static DateTime? _appStartTime;

  static Future<void> init() {
    _appStartTime = DateTime.now();
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,

    );
  }

  static final _instance = FirebaseAnalytics.instance;

  static Future<void> logAppTermination() async {
    DateTime appTerminationTime = DateTime.now();
    Duration timeSpent = appTerminationTime.difference(_appStartTime!);
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
      name: 'time_spent_inside_app',
      parameters: <String, dynamic>{
        'time_spent': timeSpent.inSeconds,
        'user_gender':userInfo['gender'],
        'user_age':userInfo['age'].toString(),
        'user_email':userInfo['email'],
        'username': userInfo['username'],
      },
    );
  }

  static void setUserProperties(String email, String gender, int age) {
    _instance.setUserProperty(name: 'email', value: email);
    _instance.setUserProperty(name: 'gender', value: gender);
    _instance.setUserProperty(name: 'age', value: age.toString());
  }

  static void onUserLogin(String email, String gender, int age,String username) async {
    _instance.setAnalyticsCollectionEnabled(true);
    setUserProperties(email, gender, age);
    _instance.logLogin(
        loginMethod:username,
        parameters: <String, dynamic>{
          'email': email,
          'gender': gender,
          'age': age.toString(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email_analytics', email);
    await prefs.setString('user_gender_analytics', gender);
    await prefs.setInt('user_age_analytics', age);
    await prefs.setString('username_analytics', username);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email_analytics');
    String? gender = prefs.getString('user_gender_analytics');
    int? age = prefs.getInt('user_age_analytics');
    String? username = prefs.getString('username_analytics');

    return {
      'email': email ?? '',
      'gender': gender ?? '',
      'age': age ?? 0,
      'username': username ?? '',
    };
  }

  static void recipeViewed(String recipeName) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
      name: "viewed_recipe",
      parameters: <String, dynamic>{
        'recipe_name': recipeName,
        'user_gender':userInfo['gender'],
        'user_age':userInfo['age'].toString(),
        'user_email':userInfo['email'],
        'username': userInfo['username'],
      },
    );
  }

  static void recipeLiked(String recipeName) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
      name: "liked_recipe",
      parameters: <String, dynamic>{
        'recipe_name': recipeName,
        'user_gender':userInfo['gender'],
        'user_age':userInfo['age'].toString(),
        'user_email':userInfo['email'],
        'username': userInfo['username'],
      },
    );
  }

  static void recipeDisliked(String recipeName) async {
  Map<String, dynamic> userInfo = await getUserInfo();
  _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
      name: "liked_recipe",
      parameters: <String, dynamic>{
        'recipe_name': recipeName,
        'user_gender':userInfo['gender'],
        'user_age':userInfo['age'].toString(),
        'user_email':userInfo['email'],
        'username': userInfo['username'],
      },
    );
  }

  static void recipeAddedToPlan(String recipeName) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance
        .logEvent(name: 'recipes_added_to_plan', parameters: <String, dynamic>{
      'recipes_name': recipeName,
      'user_gender':userInfo['gender'],
      'user_age':userInfo['age'].toString(),
      'user_email':userInfo['email'],
      'username': userInfo['username'],
    });
  }

  static void searchedQuery(String query) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(name: "search_query", parameters: <String, dynamic>{
      'query': query,
      'user_gender':userInfo['gender'],
      'user_age':userInfo['age'].toString(),
      'user_email':userInfo['email'],
      'username': userInfo['username'],
    });
  }

  static void screenViewed(String screenName) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logScreenView(
        screenName:screenName,
        parameters: <String, dynamic>{
          'user_gender':userInfo['gender'],
          'user_age':userInfo['age'].toString(),
          'user_email':userInfo['email'],
          'username': userInfo['username'],
        }
    );
  }

  static void timeSpent(Duration timeSpent) {
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
        name: 'time_spent_inside_app',
        parameters: <String, dynamic>{'time_spent': timeSpent.toString()});
  }

  static void purchaseIngredient(String ingredientName) async {
    Map<String, dynamic> userInfo = await getUserInfo();
    _instance.setAnalyticsCollectionEnabled(true);
    _instance.logEvent(
        name: 'purchase_ingredient',
        parameters: <String,dynamic>{
          'ingredient_name':ingredientName,
          'user_gender':userInfo['gender'],
          'user_age':userInfo['age'].toString(),
          'user_email':userInfo['email'],
          'username': userInfo['username'],
        }
    );
  }
}
