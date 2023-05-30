import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jom_ride/providers/auth_provider.dart';
import 'package:jom_ride/routes.dart';
import 'package:jom_ride/screens/home.dart';
import 'package:jom_ride/screens/map.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Get.find();
  }

  String get initialRoute {
    if (authProvider.loggedIn) {
      return MapScreen.routeName;
    } else {
      return HomeScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: routes,
    );
  }
}
