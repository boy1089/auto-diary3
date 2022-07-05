import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CounterPage()

        // home: Scaffold(
        //
        );
  }
}
//

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  double latitude = 0;
  double longitude = 0;
  String location = 'a';

  int screenIndex = 1;
  List<Widget> screenList = [Text('home'), Text('setting')];

  final StreamController<int> _streamController = StreamController();
  final Stream<int> stream =
      Stream.periodic(Duration(seconds: 3), (int x) => x); // 1초에 한번씩 업데이트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Hello"),
            // 1. 버튼 누를 때마다 텍스트 변경
            StreamBuilder<int>(
              stream: _streamController.stream, // 어떤 스트림을 쓸지 정함
              initialData: _counter, // 초기값 정하기, 스트림에 값이 없을지도 모르니 초기값을 정함.
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                // UI 만드는 부분.
                return Text('You hit me ${snapshot.data} times');
              },
            ),
            // 2. 1초마다 텍스트 변경
            StreamBuilder<int>(
              stream: stream, //
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                _getCurrentLocation();
                print('$location');

                return Text('${location} seconds passed'); // 1초에 한번씩 업데이트 된다.
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting'),
          ],
          onTap: (value) {
            setState(() {
              if (value == 1) Navigator.pushNamed(context, '/setting');
              if (value == 0) Navigator.pushNamed(context, '/home');
              print('$value');
            });
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _streamController.sink.add(++_counter);
          _write(location);
        },
      ),
    );
  }

  void _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    // final Directory directory = await getTemporaryDirectory();
    final now = DateTime.now();
    // print(directory.path);
    final File file = File('${directory.path}/location/my_file.txt');
    await file.writeAsString('$now, $text, \n', mode: FileMode.append);
  }

  Future<void> _getCurrentLocation() async {
    //
    // bool serviceEnabled;
    // LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }
    //
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }
    //
    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // latitude = position.latitude;
    // longitude = position.longitude;
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(latitude, longitude);
    // location = placemarks[2].name.toString();
    // print('$latitude, $longitude');
  }
}
