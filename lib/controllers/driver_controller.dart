import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jom_ride/models/driver.dart';

class DriverController {
  static late CollectionReference store;
  static Future<Driver> create({
    required String userName,
    required String email,
    required String password,
    required String carPlate,
  }) async {
    DocumentReference<Object?> insertedData = await store.add({
      'user_name': userName,
      'email': email,
      'password': password,
      'car_plate': carPlate,
    });

    Driver insertedDriver = Driver(
      index: insertedData.id,
      userName: userName,
      email: email,
      password: password,
      carPlate: carPlate,
    );

    return insertedDriver;
  }

  static Future<Driver?> findIndex({
    required String index,
  }) async {
    QuerySnapshot<Object?> data =
        await store.where('index', isEqualTo: index).limit(1).get();

    if (data.size == 0) {
      return null;
    }

    Map<String, dynamic> document = data.docs[0].data() as Map<String, dynamic>;

    Driver driver = Driver(
      index: data.docs[0].id,
      userName: document['user_name'],
      email: document['email'],
      password: document['password'],
      carPlate: document['car_plate'],
    );

    return driver;
  }

  static Future<Driver?> findUserName({
    required String userName,
  }) async {
    QuerySnapshot<Object?> data =
        await store.where('user_name', isEqualTo: userName).limit(1).get();

    if (data.size == 0) {
      return null;
    }

    QueryDocumentSnapshot<Object?> object = data.docs[0];
    Map<String, dynamic> document = object.data() as Map<String, dynamic>;

    Driver driver = Driver(
      index: object.id,
      userName: document['user_name'],
      email: document['email'],
      password: document['password'],
      carPlate: document['car_plate'],
    );

    return driver;
  }

  Future<bool> checkUserNameAvailability(String userName) async {
    QuerySnapshot<Object?> data =
        await store.where('user_name', isEqualTo: userName).limit(1).get();

    if (data.size != 0) {
      return false;
    } else {
      return true;
    }
  }
}
