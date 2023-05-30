import 'package:get/get.dart';
import 'package:jom_ride/models/driver.dart';
import 'package:jom_ride/models/passenger.dart';
import 'package:jom_ride/models/user.dart';
import 'package:jom_ride/utils/user_type.dart';

class AuthProvider extends GetxController {
  late User authUser;
  late UserType authUserType;
  bool loggedIn = false;

  Driver? get authDriver {
    if (authUserType != UserType.driver) {
      return null;
    } else {
      return authUser as Driver;
    }
  }

  Passenger? get authPassenger {
    if (authUserType != UserType.passenger) {
      return null;
    } else {
      return authUser as Passenger;
    }
  }

  void login(User user) {
    loggedIn = true;
    authUser = user;
    authUserType = authUser.type;
  }

  void logout() {
    loggedIn = false;
  }
}
