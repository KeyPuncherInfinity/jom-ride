import 'package:flutter/material.dart';
import 'package:jom_ride/helpers/auth.dart';
import 'package:jom_ride/models/passenger.dart';
import 'package:jom_ride/screens/home.dart';
import 'package:jom_ride/screens/login.dart';
import 'package:jom_ride/screens/map.dart';
import 'package:jom_ride/utils/colors.dart';

class PassengerSignUpScreen extends StatefulWidget {
  static const String routeName = 'passenger-sign-up';

  const PassengerSignUpScreen({super.key});

  @override
  State<PassengerSignUpScreen> createState() => _PassengerSignUpScreenState();
}

class _PassengerSignUpScreenState extends State<PassengerSignUpScreen> {
  late TextEditingController emailController;
  late TextEditingController userNameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    Passenger passenger = await Auth.signUpPassenger(
      userName: userNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    toMapScreen();
  }

  void toLoginScreen() {
    bool popUntilPredicate(Route<dynamic> route) {
      return (route.settings.name ?? '') == HomeScreen.routeName;
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        popUntilPredicate,
      );
    }
  }

  void toMapScreen() {
    bool popUntilPredicate(Route<dynamic> route) {
      return false;
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        MapScreen.routeName,
        popUntilPredicate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Sign Up'),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEmailField(),
              buildUserNameField(),
              buildPasswordField(),
              buildSignUpButton(),
              buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email'),
        TextField(
          controller: emailController,
        ),
      ],
    );
  }

  Widget buildUserNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Name'),
        TextField(
          controller: userNameController,
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password'),
        TextField(
          controller: passwordController,
        ),
      ],
    );
  }

  Widget buildSignUpButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: signUp,
        child: Text('SIGN UP'),
      ),
    );
  }

  Widget buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: toLoginScreen,
        child: Text('ALREADY HAVE AN ACCOUNT? LOGIN NOW'),
      ),
    );
  }
}
