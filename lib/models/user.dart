import 'package:jom_ride/utils/user_type.dart';

class User {
  late String index;
  late String userName;
  late String email;
  late String password;
  late UserType type;

  User({
    required this.index,
    required this.userName,
    required this.email,
    required this.password,
    required this.type,
  });
}
