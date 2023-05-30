import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jom_ride/models/passenger.dart';

class PassengerController {
  static late CollectionReference store;
  static Future<Passenger> create({
    required String userName,
    required String email,
    required String password,
  }) async {
    DocumentReference<Object?> insertedData = await store.add({
      'user_name': userName,
      'email': email,
      'password': password,
    });

    Passenger insertedPassenger = Passenger(
      index: insertedData.id,
      userName: userName,
      email: email,
      password: password,
    );

    return insertedPassenger;
  }

  static Future<Passenger?> findIndex({
    required String index,
  }) async {
    QuerySnapshot<Object?> data =
        await store.where('index', isEqualTo: index).limit(1).get();

    if (data.size == 0) {
      return null;
    }

    QueryDocumentSnapshot<Object?> object = data.docs[0];
    Map<String, dynamic> document = object.data() as Map<String, dynamic>;

    Passenger passenger = Passenger(
      index: object.id,
      userName: document['user_name'],
      email: document['email'],
      password: document['password'],
    );

    return passenger;
  }

  static Future<Passenger?> findUserName({
    required String userName,
  }) async {
    QuerySnapshot<Object?> data =
        await store.where('user_name', isEqualTo: userName).limit(1).get();

    if (data.size == 0) {
      return null;
    }

    QueryDocumentSnapshot<Object?> object = data.docs[0];
    Map<String, dynamic> document = object.data() as Map<String, dynamic>;

    Passenger passenger = Passenger(
      index: object.id,
      userName: document['user_name'],
      email: document['email'],
      password: document['password'],
    );

    return passenger;
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
