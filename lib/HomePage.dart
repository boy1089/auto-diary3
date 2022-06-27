import 'package:flutter/material.dart';
import 'package:auto_diary3/Images.dart';

import 'dart:io';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var images = Images();
  var files = null;
  var dates;


  void initState() {
    // getFiles(); //call getFiles() function on initial state.
    super.initState();
    setState((){
      files = images.filesAll;
      dates = images.dates;});

    print("files : $files");
  }

  Widget Button(String text) {
    var date = text.substring(4, 8);
    return Container(
      // flex: 2,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(5),
        height: 20,
        child: Text("$date"),
        onPressed: () {
          Navigator.pushNamed(context, '/second', arguments: {'date': text});
        },
      ),
    );
  }

  // void getFiles() async {
  //   //asyn function to get list of files
  //   // List<StorageInfo> storageInfo = await PathProvider.getStorageInfo();
  //   // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
  //
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   var root = '/sdcard/DCIM/Camera';
  //   var fm = FileManager(root: Directory(root)); //
  //   files = await fm.filesTree(
  //       extensions: [
  //         "png",
  //         "jpg"
  //       ]
  //       );
  //
  //   files = files.where((item) => item.toString().contains('2022')).toList();
  //   var dateList = [];
  //   for (var i = 0; i < files.length; i++) {
  //     dateList.add(files[i].toString().split('/')[4].substring(0, 8));
  //   }
  //   dates = dateList.toSet().toList();
  //   setState(() {}); //update the UI
  // }
  //
  // void getDateFromFiles() async {
  //   var dateList = [];
  //   print('files_all = $files.length');
  //   for (var i = 0; i < files.length; i++) {
  //     dateList.add(files[i].toString().split('/')[4].substring(0, 8));
  //   }
  //   dates = dateList.toSet().toList();
  //   print(dates);
  //   setState(() {}); //update the UI
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: files == null
          ? Text("Searching Files")
          : SafeArea(
            minimum: EdgeInsets.all(40),
             child: GridView.builder(
               physics : NeverScrollableScrollPhysics(),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 5,
                 crossAxisSpacing: 20,
                 mainAxisSpacing: 20,
               ),

               itemCount: dates.length,
               itemBuilder: (context, index){
                 return Button(
                   dates[index]
                 );}),

               ),


        // child: Column(children: [
        //         Row(
        //           children: [
        //             // Button(dates[0]),
        //             // Button(dates[1]),
        //             // Button(dates[2]),
        //             // Button(dates[3]),
        //             // Button(dates[4]),
        //           ],
        //           mainAxisSize: MainAxisSize.max,
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //         ),
        //         SizedBox(height: 5),
        //         Row(
        //           children: [
        //             // Button(dates[5]),
        //             // Button(dates[6]),
        //             // Button(dates[7]),
        //             // Button(dates[8]),
        //             // Button(dates[9]),
        //           ],
        //           mainAxisSize: MainAxisSize.max,
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //         )
        //       ]),
        //     ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        images.updateState();
        setState((){dates = images.dates;});
        print(dates);
      }),
    );
  }
}
