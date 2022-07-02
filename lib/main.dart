import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:auto_diary3/screen2.dart';
import 'package:auto_diary3/HomePage.dart';
import 'package:auto_diary3/Images.dart';
import 'package:permission_handler/permission_handler.dart';

//TODO : location
//TODO : make new page -- enable locatio logging.
//TODO : make folder with location data.
//TODO : read location data, apply it to screen2
//TODO : read locaiton data, apply it to home page.


//TODO : try calendar view without headers.

//TODO : make scroll enabled in homepage

//TODO : create SQL to save th info

//TODO : organize the info from photo -- time, location
//TODO : get location from photo

//TODO : change hard coded values.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // home: MyFileList(date: "202210"), //call MyFile List
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
