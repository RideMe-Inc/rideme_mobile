import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideme_mobile/core/location/data/datasources/localds.dart';
import 'package:rideme_mobile/core/location/data/datasources/remoteds.dart';
import 'package:rideme_mobile/core/location/data/repository/location_repository_impl.dart';
import 'package:rideme_mobile/core/location/domain/repositories/location_repository.dart';
import 'package:rideme_mobile/core/location/domain/usecases/cache_locations.dart';
import 'package:rideme_mobile/core/location/domain/usecases/get_geo_id.dart';
import 'package:rideme_mobile/core/location/domain/usecases/retrieve_locations.dart';
import 'package:rideme_mobile/core/location/domain/usecases/search_place.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/location/presentation/providers/location_provider.dart';
import 'package:rideme_mobile/core/network/networkinfo.dart';
import 'package:rideme_mobile/core/urls/urls.dart';
import 'package:rideme_mobile/features/authentication/data/datasources/localds.dart';
import 'package:rideme_mobile/features/authentication/data/datasources/remoteds.dart';
import 'package:rideme_mobile/features/authentication/data/repository/authentication_repo_impl.dart';
import 'package:rideme_mobile/features/authentication/domain/repository/authentication_repository.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/get_refresh_token.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/init_auth.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/logout.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/recover_token.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/sign_up.dart';
import 'package:rideme_mobile/features/authentication/domain/usecases/verify_otp.dart';
import 'package:rideme_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:rideme_mobile/features/localization/data/datasources/localds.dart';
import 'package:rideme_mobile/features/localization/data/repository/repo_impl.dart';
import 'package:rideme_mobile/features/localization/domain/repository/localization_repo.dart';
import 'package:rideme_mobile/features/localization/domain/usecases/change_locale.dart';
import 'package:rideme_mobile/features/localization/domain/usecases/get_current_locale.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/onboarding/data/datasources/local_ds.dart';
import 'package:rideme_mobile/features/onboarding/data/repository/onboarding_repo_impl.dart';
import 'package:rideme_mobile/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:rideme_mobile/features/onboarding/domain/usecases/is_onboarding_viewed.dart';
import 'package:rideme_mobile/features/onboarding/domain/usecases/mark_onboarding_viewed.dart';
import 'package:rideme_mobile/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:rideme_mobile/features/permissions/data/datasources/localds.dart';
import 'package:rideme_mobile/features/permissions/data/repository/repository_impl.dart';
import 'package:rideme_mobile/features/permissions/domain/repository/permissions_repo.dart';
import 'package:rideme_mobile/features/permissions/domain/usecases/request_all_necessary_permissions.dart';
import 'package:rideme_mobile/features/permissions/domain/usecases/request_location_permission.dart';
import 'package:rideme_mobile/features/permissions/domain/usecases/request_notif_permission.dart';
import 'package:rideme_mobile/features/permissions/presentation/bloc/permission_bloc.dart';
import 'package:rideme_mobile/features/trips/data/datasource/remoteds.dart';
import 'package:rideme_mobile/features/trips/data/repository/trip_repository_impl.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/cancel_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/create_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/edit_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/fetch_pricing.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_all_trips.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_trip_info.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/initiate_tracking.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/rate_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/report_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/terminate_tracking.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/user/data/datasources/localds.dart';
import 'package:rideme_mobile/features/user/data/datasources/remoteds.dart';
import 'package:rideme_mobile/features/user/data/repositories/user_repository_impl.dart';
import 'package:rideme_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:rideme_mobile/features/user/domain/usecases/get_user_profile.dart';
import 'package:rideme_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:web_socket_client/web_socket_client.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

//! MAIN INIT FUNCTION

init() async {
  //!INTERNAL

  //permissions
  initPermissions();

  //localizations
  initLocalization();

  //onboarding

  initOnboarding();

  //auth

  initAuth();

  //user
  initUser();

  //location
  initLocation();

  //trips
  initTrips();

  //urls
  sl.registerLazySingleton(() => URLS());

  //network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: sl(),
    ),
  );

  //! EXTERNAL

  //firebase messaging

  sl.registerLazySingleton(() => FirebaseMessaging.instance);

  //data connection
  sl.registerLazySingleton(() => DataConnectionChecker());

  //shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);

  //flutter secured storage
  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  final secureStorage = FlutterSecureStorage(
    aOptions: getAndroidOptions(),
  );

  sl.registerLazySingleton(() => secureStorage);

  //http
  sl.registerLazySingleton(() => http.Client());

  //camera and image picker
  sl.registerLazySingleton(() => ImagePicker());

  //socket
  sl.registerLazySingleton<WebSocket>(() {
    final socket = WebSocket(Uri.parse('wss://dss.rideme.app/users/'));
    // final testingSocket =
    //     WebSocket(Uri.parse('wss://ws.shaqexpress.com/users/'));

    return socket;
  });
}

//!INIT PERMISSIONS
initPermissions() {
  //bloc

  sl.registerFactory(
    () => PermissionBloc(
      requestNotificationPermission: sl(),
      requestLocationPermission: sl(),
      requestAllNecessaryPermissions: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(
    () => RequestNotificationPermission(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RequestLocationPermission(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RequestAllNecessaryPermissions(
      repository: sl(),
    ),
  );

  //repository

  sl.registerLazySingleton<PermissionsRepository>(
    () => PermissionsRepositoryImpl(
      localDatasource: sl(),
    ),
  );

  //datasources

  sl.registerLazySingleton<PermissionsLocalDatasource>(
    () => PermissionsLocalDatasourceImpl(
      messaging: sl(),
    ),
  );
}

//!INIT LOCALIZATION
initLocalization() {
  //provider
  sl.registerFactory(
    () => LocaleProvider(
      getCurrentLocale: sl(),
      changeLocale: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(
    () => ChangeLocale(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetCurrentLocale(
      repository: sl(),
    ),
  );

  //repository

  sl.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<LocalizationLocalDataSource>(
    () => LocalizationLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
}

//!INIT ONBOARDING
initOnboarding() {
  //bloc
  sl.registerFactory(
    () => OnboardingBloc(
      markOnboardingViewed: sl(),
      isOnboardingViewed: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(
    () => MarkOnboardingViewed(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => IsOnboardingViewed(
      repository: sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      localDatasource: sl(),
    ),
  );

  //datasources

  sl.registerLazySingleton<OnboardingLocalDatasource>(
    () => OnboardingLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );
}

//!INIT AUTH
initAuth() {
  //bloc
  sl.registerFactory(
    () => AuthenticationBloc(
      initAuth: sl(),
      verifyOtp: sl(),
      getRefreshToken: sl(),
      recoverToken: sl(),
      signUp: sl(),
      logOut: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(() => InitAuth(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtp(repository: sl()));
  sl.registerLazySingleton(() => GetRefreshToken(repository: sl()));
  sl.registerLazySingleton(() => RecoverToken(repository: sl()));
  sl.registerLazySingleton(() => SignUp(repository: sl()));
  sl.registerLazySingleton(() => LogOut(repository: sl()));

  //repository

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
        networkInfo: sl(),
        userLocalDatasource: sl(),
        localDatasource: sl(),
        remoteDatasource: sl()),
  );

  //datasources

  sl.registerLazySingleton<AuthenticationRemoteDatasource>(
    () => AuthenticationRemoteDatasourceImpl(
        client: sl(), urls: sl(), messaging: sl()),
  );

  sl.registerLazySingleton<AuthenticationLocalDatasource>(
    () => AuthenticationLocalDatasourceImpl(secureStorage: sl()),
  );
}

//!INIT USER
initUser() {
  //bloc
  sl.registerFactory(
    () => UserBloc(
      getUserProfile: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(() => GetUserProfile(repository: sl()));

  //repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      networkInfo: sl(),
      localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  //datasources

  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(client: sl(), urls: sl()),
  );

  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(sharedPreferences: sl(), imagePicker: sl()),
  );
}

//!INIT LOCATION
initLocation() {
  //bloc

  sl.registerFactory(
    () => LocationBloc(
      searchPlace: sl(),
      getGeoID: sl(),
    ),
  );
  //provider
  sl.registerFactory(
    () => LocationProvider(
      cacheLocation: sl(),
      retrieveLocations: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(
    () => SearchPlace(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetGeoID(repository: sl()),
  );
  sl.registerLazySingleton(
    () => CacheLocation(repository: sl()),
  );

  sl.registerLazySingleton(
    () => RetrieveLocations(repository: sl()),
  );

  //repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      networkInfo: sl(),
      localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<LocationLocalDatasource>(
    () => LocationLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<LocationRemoteDatasource>(
    () => LocationRemoteDatasourceImpl(
      urls: sl(),
      client: sl(),
    ),
  );
}

//!INIT TRIPS
initTrips() {
  //bloc
  sl.registerFactory(
    () => TripsBloc(
      cancelTrip: sl(),
      createTrip: sl(),
      getAllTrips: sl(),
      rateTrip: sl(),
      getTripInfo: sl(),
      reportTrip: sl(),
      fetchPricing: sl(),
      initiateTracking: sl(),
      terminateTracking: sl(),
      editTrip: sl(),
    ),
  );

  //usecases

  sl.registerLazySingleton(
    () => InitiateTracking(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CancelTrip(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CreateTrip(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => EditTrip(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetAllTrips(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RateTrip(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetTripInfo(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ReportTrip(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FetchPricing(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => TerminateTracking(
      repository: sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<TripsRepository>(
    () => TripsRepositoryImpl(
      networkInfo: sl(),
      tripRemoteDataSource: sl(),
    ),
  );

  //datasources
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(
      urls: sl(),
      client: sl(),
      socket: sl(),
    ),
  );
}
