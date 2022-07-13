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
    return MaterialApp(home: CounterPage());
  }
}
//

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  List<double> latitude_list = [];
  List<double> longitude_list = [];
  List<String> location_list = [];
  List<DateTime> datetime_list = [];

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
            StreamBuilder<int>(
              stream: _streamController.stream, // 어떤 스트림을 쓸지 정함
              initialData: _counter, // 초기값 정하기, 스트림에 값이 없을지도 모르니 초기값을 정함.
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('You hit me ${snapshot.data} times');
              },
            ),
            StreamBuilder<int>(
              stream: stream, //
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'setting'),
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



}
