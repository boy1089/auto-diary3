
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';



class LocationLogger {
  var latitude;
  var longitude;
  var location;

  //
  // final StreamController<int> _streamController = StreamController();
  // final Stream<int> stream =
  // Stream.periodic(Duration(seconds: 3), (int x) => x); // 1초에 한번씩 업데이트
  void getGPS(){}
  void convertGPSToLocation(){}

  void saveLocation() {}



    Future<void> getCurrentLocation() async {

      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      print('location : $latitude, $longitude');
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      location = placemarks[2].name.toString();
      print('location:  $location');
    }


}