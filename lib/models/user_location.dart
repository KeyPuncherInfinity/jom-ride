import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jom_ride/utils/user_type.dart';

class UserLocation {
  String index;
  late double latitude;
  late double longitude;
  late String userIndex;
  late UserType userType;
  UserLocation({
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.userIndex,
    required this.userType,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      index: map['index'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      userIndex: map['user_index'],
      userType: UserType.values[map['user_type']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'latitude': latitude,
      'longitude': longitude,
      'user_index': userIndex,
      'user_type': userType.index,
    };
  }

  LatLng get latlng {
    return LatLng(latitude, longitude);
  }
}
