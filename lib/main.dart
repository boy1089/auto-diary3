import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:auto_diary3/screen2.dart';
import 'package:auto_diary3/HomePage.dart';
// import 'package:auto_diary3/Images.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:auto_diary3/SettingPage.dart';

//TODO : location
//TODO : classify with date.

//TODO : make new page -- enable locatio logging.
//TODO : read location data, apply it to screen2

//TODO : refactor



//TODO : try calendar view without headers.

//TODO : make scroll enabled in homepage
//TODO : make horizontal scrollable picture in screen2.

//TODO : create SQL to save th info

//TODO : organize the info from photo -- time, location
//TODO : get location from photo

//TODO : change hard coded values.

//TODO : refactor -- init things to main. -- get path, get settings. create instance

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  MyApp(){

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // home: MyFileList(date: "202210"), //call MyFile List
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomePage(),
          '/second': (context) => MyFileList(date: '202210'),
          '/setting' : (context) => SettingPage(),
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
