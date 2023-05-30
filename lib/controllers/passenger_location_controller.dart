import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jom_ride/models/user_location.dart';
import 'package:jom_ride/utils/user_type.dart';

class PassengerLocationController {
  static late CollectionReference store;

  static Future<UserLocation> create({
    required String userIndex,
    required double latitude,
    required double longitude,
    bool seaching = true,
    String driver = '',
  }) async {
    DocumentReference<Object?> insertedDocument = await store.add({
      'user_index': userIndex,
      'latitude': latitude,
      'longitude': longitude,
      'user_type': UserType.passenger.index,
      'searching': true,
      'driver': driver,
    });

    UserLocation location = UserLocation(
      index: insertedDocument.id,
      userIndex: userIndex,
      latitude: latitude,
      longitude: longitude,
      userType: UserType.passenger,
    );
    return location;
  }

  static Future<UserLocation?> findUserIndex({
    required String userIndex,
  }) async {
    QuerySnapshot<Object?> queriedData =
        await store.where('user_index', isEqualTo: userIndex).limit(1).get();

    if (queriedData.size == 0) {
      return null;
    }

    QueryDocumentSnapshot<Object?> document = queriedData.docs[0];

    if (!document.exists) {
      return null;
    }

    UserLocation location = UserLocation(
      index: document.id,
      userIndex: userIndex,
      latitude: document.get('latitude'),
      longitude: document.get('longitude'),
      userType: UserType.values[document.get('user_type')],
    );
    return location;
  }

  static Future<UserLocation> createOrUpdateUserIndex({
    required String userIndex,
    required double latitude,
    required double longitude,
  }) async {
    UserLocation? existingLocation = await findUserIndex(userIndex: userIndex);

    if (existingLocation == null) {
      UserLocation location = await create(
        latitude: latitude,
        longitude: longitude,
        userIndex: userIndex,
      );
      return location;
    } else {
      store.doc(existingLocation.index).set({
        'user_index': userIndex,
        'latitude': latitude,
        'longitude': longitude,
        'user_type': UserType.passenger.index,
        'searching': true,
        'driver': '',
      });
      UserLocation location = UserLocation(
        index: existingLocation.index,
        userIndex: userIndex,
        latitude: latitude,
        longitude: longitude,
        userType: UserType.passenger,
      );
      return location;
    }
  }

  static Future<UserLocation?> updateUserIndex({
    required String userIndex,
    required double latitude,
    required double longitude,
  }) async {
    UserLocation? existingLocation = await findUserIndex(userIndex: userIndex);

    if (existingLocation == null) {
      return null;
    }

    store.doc(existingLocation.index).set({
      'user_index': userIndex,
      'latitude': latitude,
      'longitude': longitude,
      'user_type': UserType.passenger.index,
      'searching': true,
      'driver': '',
    });

    UserLocation location = UserLocation(
      index: existingLocation.index,
      userIndex: userIndex,
      latitude: latitude,
      longitude: longitude,
      userType: UserType.passenger,
    );
    return location;
  }

  static Future<bool> selectPassenger({
    required String passengerIndex,
    required String driverIndex,
  }) async {
    UserLocation? existingLocation = await findUserIndex(
      userIndex: passengerIndex,
    );
    if (existingLocation == null) {
      return false;
    }
    store.doc(existingLocation.index).update({
      'searching': false,
      'driver': driverIndex,
    });
    return true;
  }

  static Future<Stream<DocumentSnapshot<Object?>>> streamIndex(
      {required String index}) async {
    UserLocation? existingLocation = await findUserIndex(userIndex: index);
    return store.doc(existingLocation!.index).snapshots();
  }

  static Stream<QuerySnapshot<Object?>> streamAll() {
    return store.snapshots();
  }
}
