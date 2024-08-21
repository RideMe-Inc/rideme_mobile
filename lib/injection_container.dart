import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
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
