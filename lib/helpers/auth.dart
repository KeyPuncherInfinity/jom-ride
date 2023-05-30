import 'package:get/get.dart';
import 'package:jom_ride/helpers/local_store.dart';
import 'package:jom_ride/providers/auth_provider.dart';
import 'package:jom_ride/controllers/driver_controller.dart';
import 'package:jom_ride/controllers/passenger_controller.dart';
import 'package:jom_ride/models/driver.dart';
import 'package:jom_ride/models/passenger.dart';
import 'package:jom_ride/utils/user_type.dart';

class Auth {
  static Future<Passenger> signUpPassenger({
    required String userName,
    required String email,
    required String password,
  }) async {
    Passenger passenger = await PassengerController.create(
      userName: userName,
      email: email,
      password: password,
    );

    AuthProvider authProvider = Get.find();
    authProvider.login(passenger);
    LocalStore.writeAuthUser(passenger.toMap());
    return passenger;
  }

  static Future<Driver> signUpDriver({
    required String userName,
    required String email,
    required String password,
    required String carPlate,
  }) async {
    Driver driver = await DriverController.create(
      userName: userName,
      email: email,
      password: password,
      carPlate: carPlate,
    );

    AuthProvider authProvider = Get.find();
    authProvider.login(driver);
    LocalStore.writeAuthUser(driver.toMap());

    return driver;
  }

  static Future<Passenger> loginPassenger({
    required String userName,
    required String password,
  }) async {
    Passenger? passenger = await PassengerController.findUserName(
      userName: userName,
    );
    if (passenger == null) {
      throw 'user_not_found';
    }

    if (passenger.password != password) {
      throw 'incorrect_password';
    }

    AuthProvider authProvider = Get.find();
    authProvider.login(passenger);
    LocalStore.writeAuthUser(passenger.toMap());

    return passenger;
  }

  static Future<Driver> loginDriver({
    required String userName,
    required String password,
  }) async {
    Driver? driver = await DriverController.findUserName(
      userName: userName,
    );
    if (driver == null) {
      throw 'user_not_found';
    }
    if (driver.password != password) {
      throw 'incorrect_password';
    }

    AuthProvider authProvider = Get.find();
    authProvider.login(driver);
    LocalStore.writeAuthUser(driver.toMap());

    return driver;
  }

  static Future<bool> autoLogin() async {
    Map<String, dynamic>? authUserMap = LocalStore.readAuthUser();
    if (authUserMap == null) {
      return false;
    }

    if (authUserMap['user_type'] == UserType.passenger.index) {
      Passenger passenger = Passenger.fromMap(authUserMap);
      AuthProvider authProvider = Get.find();
      authProvider.login(passenger);
    } else {
      Driver driver = Driver.fromMap(authUserMap);
      AuthProvider authProvider = Get.find();
      authProvider.login(driver);
    }

    return true;
  }
}
