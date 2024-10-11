import 'package:get_it/get_it.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/AddRecipe/Data/datasources/creator_recipe_remote_data_source.dart';
import 'package:ukla_app/features/AddRecipe/Data/repositories/creator_recipe_repository_impl.dart';
import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/add_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/delete_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/get_creator_recipe_list.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/update_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_bloc.dart';
import 'package:ukla_app/features/authentification/Data/google_signin_api.dart';
import 'package:ukla_app/features/ads/Data/datasources/banner_ad_remote_data_source.dart';
import 'package:ukla_app/features/ads/Data/repositories/banner_ad_repository_impl.dart';
import 'package:ukla_app/features/ads/Domain/repositories/banner_ad_repository.dart';
import 'package:ukla_app/features/ads/Domain/usecases/get_banner_ad_by_id.dart';
import 'package:ukla_app/features/ads/Domain/usecases/increment_views_count.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_bloc.dart';
import 'package:ukla_app/features/body_needs_estimation/data/datasources/body_info_remote_data_source.dart';
import 'package:ukla_app/features/body_needs_estimation/data/repositories/body_info_repository_impl.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/repositories/body_info_repository.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/usecases/add_female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/usecases/add_male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/bloc/body_info_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ukla_app/features/groceries/Data/datasources/grocery_remote_data_source.dart';
import 'package:ukla_app/features/groceries/Data/repositories/grocery_repository_impl.dart';
import 'package:ukla_app/features/groceries/Domain/repositories/grocery_repository.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/get_groceries_list.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/delete_ingredient.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/unpurchase_ingredient.dart';
import 'package:ukla_app/features/groceries/Presentation/bloc/grocery_bloc.dart';
import 'package:ukla_app/features/intake_estimation/Domain/usecases/add_estimation_recipe.dart';
import 'package:ukla_app/features/intake_estimation/Domain/usecases/get_estimation_ingredients.dart';
import 'package:ukla_app/features/intake_estimation/Presentation/bloc/intake_estimation_bloc.dart';
import 'features/groceries/Domain/usecases/purchase_ingredient.dart';
import 'features/intake_estimation/Data/datasources/intake_estimation_remote_data_source.dart';
import 'features/intake_estimation/Data/repositories/intake_estimation_repository_impl.dart';
import 'features/intake_estimation/Domain/repositories/intake_estimation_repository.dart';
import 'features/intake_estimation/Domain/usecases/add_estimation_meals.dart';
import 'features/intake_estimation/Domain/usecases/add_list_estimation_ingredient_quantities_to_estimaton_recipe.dart';
import 'features/intake_estimation/Domain/usecases/get_estimation_ingredien_by_namet.dart';
import 'features/intake_estimation/Domain/usecases/get_estimation_ingredient_quantities.dart';
import 'features/intake_estimation/Domain/usecases/get_estimation_meal.dart';
import 'features/intake_estimation/Domain/usecases/get_estimation_meals.dart';

final sl = GetIt.instance; // sl for service locator
//final slt = GetIt.instance;

void init() {
  //! Features - body needs estimation
  // Bloc
  sl.registerFactory(
      () => BodyInfoBloc(addFemaleBodyInfo: sl(), addMaleBodyInfo: sl()));
  // usecases
  sl.registerLazySingleton(() => AddFemaleBodyInfo(repository: sl()));
  sl.registerLazySingleton(() => AddMaleBodyInfo(repository: sl()));
  // repository
  sl.registerLazySingleton<BodyInfoRepository>(
      () => BodyInfoRepositiryImpl(remoteDataSource: sl()));

  // data sources
  sl.registerLazySingleton<BodyInfoRemoteDataSource>(
      () => BodyInfoRemoteDataSourceImpl(client: sl()));

  //! Features - intake estimation
  // Bloc
  sl.registerFactory(() => IntakeEstimationBloc(
      addEstimationMeals: sl(),
      getEstimationMeals: sl(),
      addEstimationRecipe: sl(),
      getEstimationIngredients: sl(),
      getEstimationIngredientsQuantites: sl(),
      addListOfEstimationIngredientQuantitiesToEstimatonRecipe: sl(),
      getEstimationMeal: sl(),
      getEstimationIngredientsByName: sl()));
  // usecases
  sl.registerLazySingleton(() => AddEstimationMeals(repository: sl()));
  sl.registerLazySingleton(() => GetEstimationMeals(repository: sl()));
  sl.registerLazySingleton(() => AddEstimationRecipe(repository: sl()));
  sl.registerLazySingleton(() => GetEstimationIngredients(repository: sl()));
  sl.registerLazySingleton(
      () => GetEstimationIngredientQuantities(repository: sl()));
  sl.registerLazySingleton(() =>
      AddListOfEstimationIngredientQuantitiesToEstimatonRecipe(
          repository: sl()));
  sl.registerLazySingleton(() => GetEstimationMeal(repository: sl()));
  sl.registerLazySingleton(
      () => GetEstimationIngredientsByName(repository: sl()));
  // repository
  sl.registerLazySingleton<IntakeEstimationRepository>(
      () => IntakeEstimationRepositoryImpl(remoteDataSource: sl()));

  // data sources
  sl.registerLazySingleton<IntakeEstimationRemoteDataSource>(
      () => IntakeEstimationRemoteDataSourceImpl(client: sl()));

  //! Features - Groceery List
  // Bloc
  sl.registerFactory(() => GroceryBloc(getGroceriesList: sl(), purchaseGroceryListIngredient: sl(), unpurchaseGroceryListIngredient: sl(), deleteGroceryListIngredient: sl()));
  //usecases
  sl.registerLazySingleton(() => GetGroceriesList(groceryRepository: sl()));
  sl.registerLazySingleton(() => PurchaseGroceriesListIngredient(groceryRepository: sl()));
  sl.registerLazySingleton(() => UnpurchaseGroceriesListIngredient(groceryRepository: sl()));
  sl.registerLazySingleton(() => DeleteGroceriesListIngredient(groceryRepository: sl()));

  //repository
  sl.registerLazySingleton<GroceryRepository>(() => GroceryRepositoryImpl(remoteDataSource: sl()));
  // data sourcces
  sl.registerLazySingleton<GroceryRemoteDataSource>(() => GroceryListRemoteDataSourceImpl(client: sl()));
  //! Features - CreatorRecipe
  // Bloc
  sl.registerFactory(() => CreatorRecipeBloc(getCreatorRecipeList: sl(),deleteCreatorRecipe: sl(), addCreatorRecipe: sl(), updateCreatorRecipe: sl()));
  //usecases
  sl.registerLazySingleton(() => GetCreatorRecipeList(repository: sl()));
  sl.registerLazySingleton(() => DeleteCreatorRecipe(repository: sl()));
  sl.registerLazySingleton(() => UpdateCreatorRecipe(repository: sl()));
  sl.registerLazySingleton(() => AddCreatorRecipe(repository: sl()));
  //repository
  sl.registerLazySingleton<CreatorRecipeRepository>(() => CreatorRecipeRepositoryImpl(remoteDataSource: sl()));
  // data sourcces
  sl.registerLazySingleton<CreatorRecipeRemoteDataSource>(() => CreatorRecipeRemoteDataSourceImpl(client: sl()));
  //! Features - BannerAd
  // Bloc
  sl.registerFactory(() => BannerAdBloc(getBannerAdById: sl(), incrementViewsCount: sl()));
  //usecases
  sl.registerLazySingleton(() => GetBannerAdById(bannerAdRepository: sl()));
  sl.registerLazySingleton(() => IncrementViewsCount(bannerAdRepository: sl()));
  //repository
  sl.registerLazySingleton<BannerAdRepository>(() => BannerAdRepositoryImpl(remoteDataSource: sl()));
  // data sourcces
  sl.registerLazySingleton<BannerAdRemoteDataSource>(() => BannerAdRemoteDataSourceImpl(client: sl()));
  //! Core

  //! External
  sl.registerLazySingleton<HttpService>(() => HttpService());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GoogleSignInApi());
}
