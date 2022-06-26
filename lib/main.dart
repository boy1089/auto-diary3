import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:auto_diary3/screen2.dart';
import 'package:auto_diary3/HomePage.dart';
import 'package:auto_diary3/ImageCollector.dart';
import 'package:permission_handler/permission_handler.dart';

//TODO : make dataframe to handle image effectively.
//TODO : make griditems and put the number of photos of each day
//TODO : make group for each month
//TODO : try calendar view without headers.
//TODO : create class with image info
//TODO : create SQL to save th info
//TODO : create jpg to save the images.

//TODO : organize the info from photo -- time, location
//TODO : get location from photo

//TODO : change hard coded values.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var a = ImageCollector();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: MyFileList(date: "202210"), //call MyFile List
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomePage(),
          '/second': (context) => MyFileList(date: '202210'),
        },
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name == '/second') {
            final args = routeSettings.arguments;
            return MaterialPageRoute(builder: (context) {
              return MyFileList(date: args.toString());
            });
          }
        });
  }
}
//
