import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hakawi/common/routes/routes.dart';
import 'package:hakawi/common/theme/dark_theme.dart';
import 'package:hakawi/common/theme/light_theme.dart';
import 'package:hakawi/feature/auth/controller/auth_controller.dart';
import 'package:hakawi/feature/home/pages/home_page.dart';
import 'package:hakawi/feature/welcome/pages/welcome_page.dart';
import 'package:hakawi/firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '7akawi',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: ref.watch(userInfoAuthProvider).when(
            data: (user) {
              FlutterNativeSplash.remove();
              if (user == null) return const WelcomePage();
              return const HomePage();
            },
            error: (error, trace) {
              return const Scaffold(
                body: Center(
                  child: Text('Something wrong happened'),
                ),
              );
            },
            loading: () => const SizedBox(),
          ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
