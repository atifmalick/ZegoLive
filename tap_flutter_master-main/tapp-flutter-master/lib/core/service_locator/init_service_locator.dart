import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapp/core/service_locator/init_service_locator.config.dart';
import 'package:tapp/core/services/navigation_service.dart';

// Dependency Injection (DI) with GetIt.
// Every feature has its own init file at the root of its folder.
// Here, the initServiceLocator() only calls the other init feature functions
// and initialize third party packages such as Firebase or GraphQLClient.
// So, for example, auth feature has an init_auth_di.dart and inside a function to
// initialize its blocs, repositories and other dependencies.

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await $initGetIt(getIt);

  final prefs = getIt<SharedPreferences>();

  if (prefs.getBool('first_run') ?? true) {
    await FirebaseAuth.instance.signOut();

    prefs.setBool('first_run', false);
  }

  getIt.registerLazySingleton(() => NavigationService());
}
