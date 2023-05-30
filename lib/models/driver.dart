import 'package:jom_ride/models/user.dart';
import 'package:jom_ride/utils/user_type.dart';

class Driver extends User {
  late String carPlate;

  Driver({
    required String index,
    required String userName,
    required String email,
    required String password,
    required this.carPlate,
  }) : super(
          index: index,
          userName: userName,
          email: email,
          password: password,
          type: UserType.driver,
        );

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      index: map['index'],
      userName: map['user_name'],
      email: map['email'],
      password: map['password'],
      carPlate: map['car_plate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'user_name': userName,
      'email': email,
      'password': password,
      'car_plate': carPlate,
      'user_type': type.index,
    };
  }
}
