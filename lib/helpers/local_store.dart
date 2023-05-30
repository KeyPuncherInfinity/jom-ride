import 'package:get_storage/get_storage.dart';
import 'package:jom_ride/utils/constants.dart';

class LocalStore {
  static late GetStorage store;

  static Future<void> writeAuthUser(Map<String, dynamic> userMap) async {
    store.write(LocalStoreKeys.authUser, userMap);
  }

  static Map<String, dynamic>? readAuthUser() {
    if (!store.hasData(LocalStoreKeys.authUser)) {
      return null;
    } else {
      return store.read(LocalStoreKeys.authUser);
    }
  }
}
