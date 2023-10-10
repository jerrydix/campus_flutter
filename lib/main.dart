import 'dart:io';

import 'package:campus_flutter/base/networking/protocols/main_api.dart';
import 'package:campus_flutter/base/services/compatability_service.dart';
import 'package:campus_flutter/loginComponent/viewModels/login_viewmodel.dart';
import 'package:campus_flutter/loginComponent/views/confirm_view.dart';
import 'package:campus_flutter/loginComponent/views/login_view.dart';
import 'package:campus_flutter/navigation.dart';
import 'package:campus_flutter/placesComponent/services/mapThemeService.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:campus_flutter/routes.dart';
import 'package:campus_flutter/theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _initApp();
  runApp(const ProviderScope(child: CampusApp()));
}

_initApp() async {
  getIt.registerSingleton<CompatabilityService>(CompatabilityService());
  getIt.registerSingleton<ConnectivityResult>(
      await Connectivity().checkConnectivity());
  getIt.registerSingleton<MapThemeService>(MapThemeService());
  if (getIt<CompatabilityService>().isWeb) {
    getIt.registerSingleton<MainApi>(MainApi.webCache());
  } else {
    if (getIt<CompatabilityService>().isMobile) {
      getIt.registerSingleton<List<AvailableMap>>(
          await MapLauncher.installedMaps);
    }
    final directory = await getTemporaryDirectory();
    HiveCacheStore(directory.path).clean();
    getIt.registerSingleton<MainApi>(
        MainApi.mobileCache(await getTemporaryDirectory()));
  }
}

class CampusApp extends ConsumerWidget {
  const CampusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: "TUM Campus App",
        debugShowCheckedModeBanner: false,
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        themeMode: ref.watch(appearance).themeMode,
        locale: ref.watch(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          confirm: (context) => const ConfirmView(),
        },
        home: const AuthenticationRouter());
  }
}

class AuthenticationRouter extends ConsumerStatefulWidget {
  const AuthenticationRouter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationRouterState();
}

class _AuthenticationRouterState extends ConsumerState<AuthenticationRouter> {
  @override
  void initState() {
    ref.read(loginViewModel).checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.watch(loginViewModel).credentials,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ref.read(userPreferencesViewModel).loadUserPreferences();
            FlutterNativeSplash.remove();
            if (snapshot.data == Credentials.tumId ||
                snapshot.data == Credentials.noTumId) {
              return const Navigation();
            } else {
              return const LoginView();
            }
          } else {
            return const LoginView();
          }
        });
  }
}
