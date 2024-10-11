import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

import 'package:ukla_app/core/Presentation/resources/routes_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/core/utils/utils.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_bloc.dart';

import 'package:ukla_app/features/plan_Management/Domain/Entity/Plan.dart';

import 'package:ukla_app/features/signup/Presentation/provider/new_account_provider.dart';
import 'package:ukla_app/injection_container.dart';

import 'package:ukla_app/models/provider/dayprovider.dart';
import 'package:ukla_app/models/provider/MealProvider.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Localizations/app_localizations.dart';

import 'conectivityChecker/internet/internet_bloc.dart';
import 'features/Splash_Screen/Presentation/SplashScreen.dart';
import 'features/body_needs_estimation/domain/entities/BodyInfo.dart';

import 'package:flutter/services.dart';

import 'features/view_recipe/Domain/Entities/recipe.dart';
import 'features/view_recipe/Domain/chewie_player.dart';
import 'injection_container.dart' as di;

const storage = FlutterSecureStorage();

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

void main() async {
  //remove the ! to enable device preview
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await FireBaseAnalyticsEvents.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedContentLanguage(),
      child: const MyApp(),
    ),
  );

  di.init(); // if we ever add an async function inside the init we need to add await here with async on main
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SystemChannels.lifecycle.setMessageHandler((msg) {
    if (msg == AppLifecycleState.paused.toString()) {
      FireBaseAnalyticsEvents.logAppTermination();
      VideoPlayerRegistry.pause();
    }
    if (msg == AppLifecycleState.resumed.toString()) {
      VideoPlayerRegistry.resume();
    }
    return Future.value('');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<CreatorRecipeBloc>(
          create: (context) => sl<CreatorRecipeBloc>(),
        ),
        ChangeNotifierProvider(
          create: (context) => CodeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewAccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlanProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => indexTabBarPlan(),
        ),
        ChangeNotifierProvider(
          create: (context) => SelectedReceipe(),
        ),
        ChangeNotifierProvider(
          create: (context) => indexMeal(),
        ),
        ChangeNotifierProvider(
          create: (context) => BodyInfoProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => SL(),
        // ),
        ChangeNotifierProvider(
          create: (context) => MealProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => DayProvider(),
        // ),
        ChangeNotifierProvider(
          create: (context) => DayProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => indexSarchedRecipes(),
        ),
        ChangeNotifierProvider(
          create: (context) => selectedRecipes(),
        ),
        ChangeNotifierProvider(
          create: (context) => testdeleteicon(),
        ),
        ChangeNotifierProvider(create: (_) => FiltredRecipeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ViewedIngredientAdProvider()),
        ChangeNotifierProvider(create: (_) => ViewedIngredientAdIdsProvider()),
        ChangeNotifierProvider(create: (context) => GroceryListLengthState()),
        ChangeNotifierProvider(create: (_) => AdDisplayCountModel()),
        ChangeNotifierProvider(create: (context) => CreatorRecipePorvider())
      ],
      //testdeleteicon
      child: ValueListenableBuilder<Locale?>(
        valueListenable:
            Provider.of<SelectedContentLanguage>(context)._localeNotifier,
        builder: (context, locale, child) {
          final deviceLocale = WidgetsBinding.instance.window.locale;
          Size size = MediaQuery.of(context).size;
          return BlocProvider(
            create: (context) => InternetBloc()..add(ConnectedEvent()),
            child: ScreenUtilInit(
              designSize: Size(size.width, size.height),
              ensureScreenSize: true,
              minTextAdapt: true,
              splitScreenMode: true,
              // Use builder only if you need to use library outside ScreenUtilInit context
              builder: (_, child) {
                return MaterialApp(
                  navigatorKey: locator<NavigationService>().navigatorKey,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('ar'),
                    Locale('fr')
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    for (var locale in supportedLocales) {
                      if (deviceLocale != null &&
                          deviceLocale.languageCode == locale.languageCode) {
                        return deviceLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  onGenerateRoute: RouteGenerator.getRoute,
                  locale: locale ?? deviceLocale,
                  home: const SplashScreen(),
                  initialRoute: Routes.splashRoute,
                  title: 'Authentication Demo',
                  theme: ThemeData(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbVisibility: MaterialStateProperty.all(true),
                      radius: const Radius.circular(10),
                      thickness: MaterialStateProperty.all(8),
                    ),
                    textSelectionTheme:
                        const TextSelectionThemeData(cursorColor: Colors.black),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            AppColors.buttonTextColor),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                    scaffoldBackgroundColor:
                        const Color.fromARGB(255, 253, 253, 253),
                    fontFamily: 'Noto Sans',
                    inputDecorationTheme: const InputDecorationTheme(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  builder: (context, child) {
                    return BlocListener<InternetBloc, InternetState>(
                      listener: (context, state) {
                        if (state is NotConnectedState) {
                          final snackBar = SnackBar(
                            content: Text("No internet connection".tr(context)),
                            action: SnackBarAction(
                              label: 'Ignore'.tr(context),
                              textColor: AppColors.primaryColor,
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(
                                right: 10, left: 10, bottom: 10),
                            duration: const Duration(minutes: 1),
                            backgroundColor: AppColors.buttonTextColor,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (state is ConnectedState) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        }
                      },
                      child: child!,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AdDisplayCountModel extends ChangeNotifier {
  int _countForRecipe = 1;
  int _countForSteps = 1;
  int get countForRecipe => _countForRecipe;
  int get countForSteps => _countForSteps;

  Future<void> incrementAndLoad(bool fromStep) async {
    final prefs = await SharedPreferences.getInstance();
    int currentCountForRecipe = prefs.getInt('adDisplayCountForRecipe')?? 1;
    int currentCountForStep = prefs.getInt('adDisplayCountForStep')?? 1;
    if(fromStep){
      if(currentCountForStep>3){
        currentCountForStep=1;
      }
      _countForSteps = currentCountForStep + 1;
      await prefs.setInt('adDisplayCountForStep', _countForSteps);
      notifyListeners();
    }else{
      if(currentCountForRecipe>3){
        currentCountForRecipe=1;
      }
      _countForRecipe = currentCountForRecipe + 1;
      await prefs.setInt('adDisplayCountForRecipe', _countForRecipe);
      notifyListeners();
    }

  }
}

class GroceryListLengthState with ChangeNotifier {
  int _loadedListLength = 0;

  int get loadedListLength => _loadedListLength;

  void setLoadedListLength(int length) {
    _loadedListLength = length;
    notifyListeners();
  }
}

class ViewedIngredientAdIdsProvider extends ChangeNotifier {
  List<int> _viewedIngredientAdIds = [];

  List<int> get viewedIngredientAdIds => _viewedIngredientAdIds;

  void addViewedIngredientAdId(int id) {
    if (!_viewedIngredientAdIds.contains(id)) {
      _viewedIngredientAdIds.add(id);
      notifyListeners();
    }
  }

  void clearViewedIngredientAdIds() {
    _viewedIngredientAdIds.clear();
    notifyListeners();
  }
}
class ViewedIngredientAdProvider extends ChangeNotifier{
  late List<int> idsList = [];
  setIdsList(List<int> ids){
    idsList = ids;
  }
  List<int> get _idsList => idsList;

}

class SelectedContentLanguage extends ChangeNotifier {
  SelectedContentLanguage() {
    _loadLanguageCode();
    loadContentLanguageCode();
  }
  final String defaultLocale = Platform.localeName;
  String _contentLanguageCode = 'en';
  final ValueNotifier<Locale> _localeNotifier =
      ValueNotifier<Locale>(Locale(Platform.localeName));
  Locale get locale => _localeNotifier.value;

  String get contentLanguageCode => _contentLanguageCode;

  set locale(Locale locale) {
    _localeNotifier.value = locale;
    notifyListeners();
  }

  Future<void> _loadLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('languageCode');
    if (code != null) {
      locale = Locale(code);
    }
  }

  Future<void> setContentLanguageCode(String code) async {
    _contentLanguageCode = code;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contentLanguageCode', code);
  }

  Future<void> loadContentLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('contentLanguageCode');
    if (code != null) {
      _contentLanguageCode = code;
    }
  }
}

class CreatorRecipePorvider extends ChangeNotifier {
  String? _title;
  String? _description;
  String? _videoUrl;
  int? _id;
  String? get title => _title;
  String? get description => _description;
  String? get videoUrl => _videoUrl;
  int? get id => _id;
  void setId(int id) {
    _id = id;
    notifyListeners();
  }

  void setVideoUrl(String videoUrl) {
    _videoUrl = videoUrl;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void clear() {
    _title = null;
    _description = null;
    _videoUrl = null;
  }
}

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
  }

  Future<void> loadLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('languageCode');
    if (code != null) {
      _languageCode = code;
      notifyListeners();
    }
  }
}

class CodeModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  String code = "";
  String Mail = "";

  void addMail(String m) {
    Mail = m;
    notifyListeners();
  }

  String getMail() {
    return Mail;
  }

  void add(String m) {
    code = m;
    notifyListeners();
  }

  String getCode() {
    return code;
  }
}

class ProfileProvider extends ChangeNotifier {
  int id = 0;
  String username = '';
  String email = '';
  DateTime? birthdate;

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  String getUsername() {
    return username;
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setId(int id) {
    this.id = id;
    notifyListeners();
  }

  int getId() {
    return id;
  }

  String getEmail() {
    return email;
  }

  String getBirthday() {
    return DateFormat("y-M-d").format(birthdate!);
  }

  void setBirthday(DateTime birthday) {
    birthdate = birthday;
    notifyListeners();
  }
}

// to save the informations of  selected plan  in the provider
class PlanProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  String PlanName = "";
  int idPlan = 0;
  int listlength = 0;

  late List<String> week;
  late List<int> id_days;
  late PlanApi plan;
  String mealtitle = "new meal";
  late int? mealIndex;
  late int index = getCurrentDayIndex(plan);
  bool favorties = false;
  double caloriesPerDay = 0;

  setCaloriesPerDay(double calories) {
    caloriesPerDay = calories;
    notifyListeners();
  }

  double getCaloriesPerDay() {
    return caloriesPerDay;
  }

  void removeRecipeFromMeal(int dayIndex, int mealIndex, int recipeId) {
    var meal = plan.days[dayIndex].meals![mealIndex];
    meal.recipes.removeWhere((recipe) => recipe.id == recipeId);
    notifyListeners();
  }

  setPlanName(String planname) {
    plan.name = planname;
    notifyListeners();
  }

  setFav(bool test) {
    favorties = test;
    notifyListeners();
  }

  bool getfav() {
    return favorties;
  }

  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }

  int getmealIndex() {
    return mealIndex!;
  }

  void addmealIndex(int id) {
    mealIndex = id;
    notifyListeners();
  }

  void addmealtitle(String m) {
    mealtitle = m;
  }

  PlanApi getplan() {
    return plan;
  }

  void setPlan(PlanApi p) {
    plan = p;
    notifyListeners();
  }

  String getmealTitle() {
    return mealtitle;
  }
}

// to save the index of selected day  in the provider
class indexTabBarPlan extends ChangeNotifier {
  int index = 0;
  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }
}

class SelectedReceipe extends ChangeNotifier {
  List<Recipe> selcetedRecipes = [];

  List<Recipe> getRecipelist() {
    return selcetedRecipes;
  }

  void addReceipe(int? id, recipe) {
    bool contains() {
      bool test = false;
      for (var element in selcetedRecipes) {
        if (element.id == id) {
          test = true;
        }
      }
      return test;
    }

    if (!contains()) {
      selcetedRecipes.add(recipe);
    }

    //if (!(this.selcetedRecipes.contains())) this.selcetedRecipes.add(receipe);
    notifyListeners();
  }

  void deleteReceipebyId(int? id) {
    selcetedRecipes.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void clearList() {
    selcetedRecipes.clear();
  }
}

// to save the index of selected meal in the provider
class indexMeal extends ChangeNotifier {
  int index = 0;
  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }
}

// to save the index of selected tabbar allrecipes / fvorites / created recipes  in the provider
class indexSarchedRecipes extends ChangeNotifier {
  int index = 0;
  String query = "";
  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }

  setQuery(String query) {
    this.query = query;
    notifyListeners();
  }

  String getQuery() {
    return query;
  }
}

// to save the list of selected recipes   in the provider
class selectedRecipes extends ChangeNotifier {
  List<Recipe> SelectedRecipes = [];
  bool? deleterecipe = false;
  setSelectedRecipes(List<Recipe> liste) {
    SelectedRecipes = liste;
    notifyListeners();
  }

  List<Recipe> getSelectedRecipes() {
    return SelectedRecipes;
  }

  setdeleterecipe(bool? test) {
    deleterecipe = test;
    notifyListeners();
  }

  bool? getdeleterecipe() {
    return deleterecipe;
  }
}

// test delete icon from buttom sheet
class testdeleteicon extends ChangeNotifier {
  bool test = false;
  setdeleteicon(bool test) {
    this.test = test;
    notifyListeners();
  }

  bool getdeleteicon() {
    return test;
  }
}

int getCurrentDayIndex(PlanApi plan) {
  final now = DateTime.now();
  bool thisweek = (now.day > plan.days[0].date.day - 1) &&
      (now.day < plan.days[6].date.day + 1);
  if (thisweek) {
    for (int i = 0; i < plan.days.length; i++) {
      if ((plan.days[i].date.day == now.day)) {
        return i;
      }
    }
  }
  return 0;
}

class BodyInfoProvider extends ChangeNotifier {
  int? calories = -1;
  late BodyInfo bodyInfo;
  setBodyInfo(BodyInfo bodyInfo) {
    this.bodyInfo = bodyInfo;
    notifyListeners();
  }

  BodyInfo getBodyInfo() {
    return bodyInfo;
  }

  setCal(int? calories) {
    this.calories = calories;
    notifyListeners();
  }

  int? getcal() {
    return calories;
  }
}

class FiltredRecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void setRecipes(List<Recipe> recipes) {
    _recipes = recipes;
    notifyListeners();
  }

  void clearRecipes() {
    _recipes.clear();
    notifyListeners();
  }
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(navigatorKey.currentState!.context)
        .showSnackBar(snackBar);
  }
}
