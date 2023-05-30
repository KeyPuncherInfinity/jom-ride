import 'package:flutter/material.dart';
import 'package:jom_ride/app.dart';
import 'package:jom_ride/init.dart';
import 'package:jom_ride/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupFirebase();
  setupFireStore();
  await setupGetStorage();
  await setupAuthProvider();

  runApp(const App());
}
