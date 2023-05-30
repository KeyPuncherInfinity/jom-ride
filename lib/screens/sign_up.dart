import 'package:flutter/material.dart';
import 'package:jom_ride/screens/driver_sign_up.dart';
import 'package:jom_ride/screens/passenger_sign_up.dart';
import 'package:jom_ride/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void toPassengerSignUp() {
    Navigator.of(context).pushNamed(PassengerSignUpScreen.routeName);
  }

  void toDriverSignUp() {
    Navigator.of(context).pushNamed(DriverSignUpScreen.routeName);
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
              onPressed: toPassengerSignUp,
              child: Text('Passenger'),
            ),
            ElevatedButton(
              onPressed: toDriverSignUp,
              child: Text('Driver'),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
