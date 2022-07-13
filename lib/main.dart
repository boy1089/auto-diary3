import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:auto_diary3/screen2.dart';
import 'package:auto_diary3/HomePage.dart';
// import 'package:auto_diary3/Images.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:auto_diary3/SettingPage.dart';



//TODO : make new page -- enable locatio logging.


//TODO : make horizontal scrollable picture in screen2.
//TODO : bug fix on homepage.

//TODO : change hard coded values.

//TODO : organize the info from photo -- time, location


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
          '/second': (context) => MyFileList(date: '20220516'),
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
