import 'package:flutter/material.dart';
import 'package:ukla_app/features/Settings/settings_interface.dart';
import 'package:ukla_app/features/authentification/Presentation/LoginScreenUpdated.dart';
import 'package:ukla_app/features/authentification/Presentation/GoogleSignupScreen.dart';
import 'package:ukla_app/features/authentification/Presentation/privacy_policy.dart';
import 'package:ukla_app/features/authentification/Presentation/terms_of_service.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/instructions.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/select_height_weigth.dart';
import 'package:ukla_app/features/forget_Password/Presentation/type_verification_code.dart';
import 'package:ukla_app/features/intake_estimation/Presentation/pages/estimation_list.dart';
import 'package:ukla_app/features/intake_estimation/Presentation/pages/info.dart';
import 'package:ukla_app/features/plan_Management/Presentation/pages/add_recipe_to_meal.dart';
import 'package:ukla_app/features/plan_Management/Presentation/pages/plan_list.dart';
import 'package:ukla_app/features/signup/Presentation/signup.dart';
import 'package:ukla_app/features/view_recipe/Presentation/one_recipe_interface.dart';

import '../../../features/Get_started/Presentation/start_the_journey.dart';
import '../../../features/Splash_Screen/Presentation/SplashScreen.dart';
import '../../../features/intake_estimation/Presentation/pages/estimation_final_list.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String signupRoute = "/signup";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String homeRoute = "/home";
  static const String mainRoute = "/main";
  static const String startjourneyRoute = "/startJourney";
  static const String viewRecipe = "/viewRecipe";
  static const String settings = "/settings";
  static const String groceries = "/groceries";

  static const String alreadyCreatedPlan = "/AlreadyCreatedPlan";
  static const String addRecipeToPlanRoute = "/addRecipeToPlan";

  static const String googeSignupRoute = "/googeSignup";
  static const String selectHeightAndWeight = "/selectHeightAndWeight";
  static const String activityResults = "/activityResults";
  static const String instructions = "/instructions";
  static const String estimationIntake = "/estimationIntake";
  static const String estimationList = "/estimationList";
  static const String estimationFinalList = "/estimationFinalList";
  static const String searchIngredient = "/searchIngredient";
  static const String ingredientQuantity = "/ingredientQuantity";
  static const String mealExample = "/mealExample";
  static const String planList = "/planList";
  static const String addRecipeToMeal = "/addRecipeToMeal";
  static const String privacyPolicy = "/privacyPolicy";
  static const String termsOfService = "/termsOfService";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.planList:
        return MaterialPageRoute(builder: (_) => const PlanList());
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreenUpdated());
      case Routes.startjourneyRoute:
        return MaterialPageRoute(builder: (_) => const StartJourney());
     /* case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());*/
      case Routes.signupRoute:
        return MaterialPageRoute(builder: (_) => const Signup());
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());
      case Routes.viewRecipe:
        return MaterialPageRoute(builder: (_) => const OneRecipeInterface());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const Settings());

      case Routes.googeSignupRoute:
        return MaterialPageRoute(builder: (_) => const GoogleSignupScreen());

      case Routes.selectHeightAndWeight:
        return MaterialPageRoute(builder: (_) => const SelectHeightWeight());

      case Routes.instructions:
        return MaterialPageRoute(builder: (_) => const Instructions(showBackArrow: true));

      case Routes.estimationIntake:
        return MaterialPageRoute(builder: (_) => const Info());
      case Routes.estimationList:
        return MaterialPageRoute(builder: (_) => const EstimationList());
      case Routes.estimationFinalList:
        return MaterialPageRoute(builder: (_) => const EstimationFinalList());
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicy());
      case Routes.termsOfService:
        return MaterialPageRoute(builder: (_) => const TermsOfService());
      /*case Routes.searchIngredient:
        return MaterialPageRoute(builder: (_) => const SearchIngredient());*/
      /*case Routes.mealExample:
        return MaterialPageRoute(builder: (_) => const MealExample());*/

      case Routes.addRecipeToMeal:
        return MaterialPageRoute(builder: (_) => AddRecipeToMeal());

      /*case Routes.ingredientQuantity:
        return MaterialPageRoute(builder: (_) => IngredientQuantity());*/

      // case Routes.mainRoute:

      //   return MaterialPageRoute(builder: (_) => const MainView());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(
                    "No Route Found"), // todo move this string to strings manager
              ),
              body: const Center(
                  child: Text(
                      "No Route Found")), // todo move this string to strings manager
            ));
  }
}
