import 'package:jom_ride/models/user.dart';
import 'package:jom_ride/utils/user_type.dart';

class Passenger extends User {
  Passenger({
    required String index,
    required String userName,
    required String email,
    required String password,
  }) : super(
          index: index,
          userName: userName,
          email: email,
          password: password,
          type: UserType.passenger,
        );

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      index: map['index'],
      userName: map['user_name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'user_name': userName,
      'email': email,
      'password': password,
      'user_type': type.index,
    };
  }
}
