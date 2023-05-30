import 'package:flutter/material.dart';
import 'package:jom_ride/helpers/auth.dart';
import 'package:jom_ride/models/driver.dart';
import 'package:jom_ride/models/passenger.dart';
import 'package:jom_ride/models/user.dart';
import 'package:jom_ride/screens/map.dart';
import 'package:jom_ride/screens/sign_up.dart';
import 'package:jom_ride/utils/colors.dart';
import 'package:jom_ride/utils/user_type.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late List<bool> selectedList;
  late UserType selectedType;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    resetSelectedList();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void resetSelectedList() {
    selectedList = [true, false];
    selectedType = UserType.passenger;
  }

  void clearSelectedList() {
    selectedList = [false, false];
  }

  void userTypeSelectionCallback(int? selectedIndex) {
    if (selectedIndex == null) {
      resetSelectedList();
      return;
    }

    clearSelectedList();
    selectedList[selectedIndex] = true;
    selectedType = UserType.values[selectedIndex];
    setState(() {});
  }

  Future<void> loginPassenger() async {
    Passenger passenger = await Auth.loginPassenger(
      userName: userNameController.text,
      password: passwordController.text,
    );
  }

  Future<void> loginDriver() async {
    Driver driver = await Auth.loginDriver(
      userName: userNameController.text,
      password: passwordController.text,
    );
  }

  Future<void> login() async {
    try {
      if (selectedType == UserType.passenger) {
        await loginPassenger();
      } else if (selectedType == UserType.driver) {
        await loginDriver();
      } else {
        return;
      }

      toMapScreen();
    } catch (err) {
      print(err);
    }
  }

  void toSignUpScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
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
        title: Text('Login'),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserNameField(),
              buildPasswordField(),
              buildUserTypeSelection(),
              buildLoginButton(),
              buildSignUpButton(),
            ],
          ),
        ),
      ),
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

  Widget buildUserTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ToggleButtons(
          fillColor: primaryGreen,
          selectedColor: white,
          isSelected: selectedList,
          onPressed: userTypeSelectionCallback,
          children: [
            Container(
              child: Text('PASSENGER'),
            ),
            Container(
              child: Text('DRIVER'),
            ),
          ],
        )
      ],
    );
  }

  Widget buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: login,
        child: Text('LOGIN'),
      ),
    );
  }

  Widget buildSignUpButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: toSignUpScreen,
        child: Text('NOT A MEMBER? SIGN UP NOW'),
      ),
    );
  }
}
