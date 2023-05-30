import 'package:flutter/material.dart';
import 'package:jom_ride/screens/driver_sign_up.dart';
import 'package:jom_ride/screens/home.dart';
import 'package:jom_ride/screens/login.dart';
import 'package:jom_ride/screens/map.dart';
import 'package:jom_ride/screens/passenger_sign_up.dart';
import 'package:jom_ride/screens/sign_up.dart';

Route<dynamic> routes(RouteSettings settings) {
  String? routeName = settings.name ?? HomeScreen.routeName;
  Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return HomeScreen();
        },
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return SignUpScreen();
        },
      );
    case PassengerSignUpScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return PassengerSignUpScreen();
        },
      );
    case DriverSignUpScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return DriverSignUpScreen();
        },
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return LoginScreen();
        },
      );
    case MapScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return MapScreen();
        },
      );

    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return HomeScreen();
        },
      );
  }
}
