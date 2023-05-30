import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jom_ride/controllers/driver_location_controller.dart';
import 'package:jom_ride/controllers/passenger_location_controller.dart';
import 'package:jom_ride/helpers/auth.dart';
import 'package:jom_ride/helpers/local_store.dart';
import 'package:jom_ride/providers/auth_provider.dart';
import 'package:jom_ride/controllers/driver_controller.dart';
import 'package:jom_ride/controllers/passenger_controller.dart';
import 'package:jom_ride/utils/firestore_collections.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp();
}

void setupFireStore() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PassengerController.store = firestore.collection(
    FireStoreCollections.passengers.name,
  );
  DriverController.store = firestore.collection(
    FireStoreCollections.drivers.name,
  );
  PassengerLocationController.store = firestore.collection(
    FireStoreCollections.passengerlocations.name,
  );
  DriverLocationController.store = firestore.collection(
    FireStoreCollections.driverlocations.name,
  );
}

Future<void> setupGetStorage() async {
  await GetStorage.init();
  LocalStore.store = GetStorage();
}

Future<AuthProvider> setupAuthProvider() async {
  AuthProvider authProvider = Get.put(
    AuthProvider(),
    permanent: true,
  );

  await Auth.autoLogin();

  return authProvider;
}
