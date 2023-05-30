import 'dart:async';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jom_ride/controllers/driver_controller.dart';
import 'package:jom_ride/controllers/driver_location_controller.dart';
import 'package:jom_ride/controllers/passenger_controller.dart';
import 'package:jom_ride/controllers/passenger_location_controller.dart';
import 'package:jom_ride/helpers/location.dart';
import 'package:jom_ride/models/user.dart';
import 'package:jom_ride/models/user_location.dart';
import 'package:jom_ride/providers/auth_provider.dart';
import 'package:jom_ride/screens/home.dart';
import 'package:jom_ride/utils/user_type.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = 'map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late AuthProvider authProvider;
  late Completer<GoogleMapController> mapController;
  late Stream<Position> currentPositionStream;
  late Stream<DocumentSnapshot<Object?>> authUserLocationStream;
  late Stream<QuerySnapshot<Object?>> userLocationStream;
  late Position currentPosition;
  late CameraPosition cameraPosition;
  late List<Marker> markerList;
  late String selectedUser = '';

  @override
  void initState() {
    super.initState();
    authProvider = Get.find();
    mapController = Completer<GoogleMapController>();
    markerList = [];
    defaultCameraPosition();
    subscibeToPositionStream();
    subscribeToAuthUserLocationStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void defaultCameraPosition() {
    cameraPosition = const CameraPosition(
      target: LatLng(20.5937, 78.9629),
      zoom: 1,
    );
  }

  Future<void> subscibeToPositionStream() async {
    currentPosition = await getCurrentPosition();
    updateCameraPosition();
    if (authProvider.authUserType == UserType.passenger) {
      PassengerLocationController.createOrUpdateUserIndex(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        userIndex: authProvider.authUser.index,
      );
    } else {
      DriverLocationController.createOrUpdateUserIndex(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        userIndex: authProvider.authUser.index,
      );
    }
    currentPositionStream = await streamCurrentPosition();
    currentPositionStream.listen(onCurrentPositionStreamEvent);
    if (authProvider.authUserType == UserType.passenger) {
      userLocationStream = DriverLocationController.streamAll();
    } else {
      userLocationStream = PassengerLocationController.streamAll();
    }
    userLocationStream.listen(onUserLocationStreamEvent);
  }

  Future<void> subscribeToAuthUserLocationStream() async {
    if (authProvider.authUserType == UserType.driver) {
      return;
    }
    authUserLocationStream = await PassengerLocationController.streamIndex(
      index: authProvider.authUser.index,
    );
    authUserLocationStream.listen(onAuthUserLocationStreamEvent);
  }

  Future<void> onAuthUserLocationStreamEvent(
    DocumentSnapshot<Object?> snapshot,
  ) async {
    if (!snapshot.exists) {
      return;
    }

    selectedUser = snapshot.get('driver');
  }

  Future<void> onCurrentPositionStreamEvent(
    Position position,
  ) async {
    currentPosition = position;
    if (selectedUser.isNotEmpty) {
      return;
    }
    updateMarker(
      authProvider.authUser,
      LatLng(position.latitude, position.longitude),
    );
    if (authProvider.authUserType == UserType.passenger) {
      PassengerLocationController.createOrUpdateUserIndex(
        userIndex: authProvider.authUser.index,
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      );
    } else {
      DriverLocationController.createOrUpdateUserIndex(
        userIndex: authProvider.authUser.index,
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onUserLocationStreamEvent(
    QuerySnapshot<Object?> snapshot,
  ) async {
    List<QueryDocumentSnapshot<Object?>> documentList = snapshot.docs;
    for (int i = 0; i < documentList.length; i++) {
      QueryDocumentSnapshot<Object?> document = documentList[i];
      if (!document.exists) {
        continue;
      }
      UserLocation location = UserLocation(
        index: document.id,
        latitude: document.get('latitude'),
        longitude: document.get('longitude'),
        userIndex: document.get('user_index'),
        userType: UserType.values[document.get('user_type')],
      );
      User? user;
      if (location.userType == UserType.passenger) {
        user = await PassengerController.findIndex(
          index: location.userIndex,
        );
      } else {
        user = await DriverController.findIndex(
          index: location.userIndex,
        );
      }
      updateMarker(
        user!,
        location.latlng,
      );
    }
    setState(() {});
  }

  Future<void> updateCameraPosition() async {
    cameraPosition = CameraPosition(
      target: LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      ),
      zoom: 100,
    );
    GoogleMapController googleMapController = await mapController.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void updateMarker(User user, LatLng coordinates) {
    int markerIndex = markerList.indexWhere((Marker marker) {
      return marker.markerId.value == user.index;
    });

    Future<void> markerTapCallback() async {
      Future<void> confirmPassengerSelection() async {
        selectedUser = user.index;
        if (mounted) {
          setState(() {});
        }
        bool success = await PassengerLocationController.selectPassenger(
          driverIndex: authProvider.authUser.index,
          passengerIndex: user.index,
        );
        if (!success) {
          return;
        }

        await DriverLocationController.stopSearching(
          driverIndex: authProvider.authUser.index,
        );
      }

      if (authProvider.authUser.type == UserType.passenger) {
        return;
      }
      if (authProvider.authUser.index == user.index) {
        return;
      }
      await showDialog(
        context: context,
        builder: (BuildContext c) {
          return SelectPassengerDialog(
            callback: confirmPassengerSelection,
          );
        },
      );
    }

    double hueColor = BitmapDescriptor.hueGreen;

    if (authProvider.authUser.index == user.index) {
      hueColor = BitmapDescriptor.hueBlue;
    }

    if (selectedUser == user.index) {
      hueColor = BitmapDescriptor.hueRed;
    }

    Marker marker = Marker(
      markerId: MarkerId(user.index),
      position: LatLng(currentPosition.latitude, currentPosition.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hueColor),
      onTap: markerTapCallback,
      infoWindow: InfoWindow(
        title: user.userName,
        snippet: '${coordinates.latitude} | ${coordinates.longitude}',
      ),
      flat: true,
    );
    if (markerIndex == -1) {
      markerList.add(marker);
    } else {
      markerList[markerIndex] = marker;
    }
  }

  void onMapCreatedCallback(GoogleMapController controller) {
    mapController.complete(controller);
  }

  void logout() {
    authProvider.logout();
    toHomeScreen();
  }

  void toHomeScreen() {
    bool popUntilPredicate(Route<dynamic> route) {
      return (route.settings.name ?? '') == HomeScreen.routeName;
    }

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        popUntilPredicate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [buildGoogleMap()],
        ),
      ),
    );
  }

  Widget buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.terrain,
      onMapCreated: onMapCreatedCallback,
      markers: markerList.toSet(),
      initialCameraPosition: cameraPosition,
    );
  }

  Widget buildOverlay() {
    return Container(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Row(
        //       children: [
        //         Countdown(
        //           build: (_, __) {

        //           }
        //           seconds: 100,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        );
  }
}

class SelectPassengerDialog extends StatelessWidget {
  final void Function() callback;
  const SelectPassengerDialog({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    void onTap() {
      callback();
      Navigator.of(context).pop();
    }

    Size size = MediaQuery.of(context).size;
    return Dialog(
        child: SizedBox(
      height: size.height * 0.2,
      width: size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Pickup Passenger'),
          ElevatedButton(
            onPressed: onTap,
            child: Text('Confirm'),
          )
        ],
      ),
    ));
  }
}
