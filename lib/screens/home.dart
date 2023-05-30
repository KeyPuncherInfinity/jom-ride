import 'package:flutter/material.dart';
import 'package:jom_ride/screens/login.dart';
import 'package:jom_ride/screens/sign_up.dart';
import 'package:jom_ride/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void toLoginScreen() {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  void toSignUpScreen() {
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: toLoginScreen,
              child: Text('Log in'),
            ),
            ElevatedButton(
              onPressed: toSignUpScreen,
              child: Text('Sign up'),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
