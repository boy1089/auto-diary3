import 'package:flutter/material.dart';
import 'package:auto_diary3/ImageCollector.dart';

import 'dart:io';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var files;
  var dates;

  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
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
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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

  void getFiles() async {
    //asyn function to get list of files
    // List<StorageInfo> storageInfo = await PathProvider.getStorageInfo();
    // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    var root = '/sdcard/DCIM/Camera';
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        //set fm.dirsTree() for directory/folder tree list
        //   excludedPaths: ["/storage/emulated/0/Android"],
        extensions: [
          "png",
          "jpg"
        ] //optional, to filter files, remove to list all,
        );

    files = files.where((item) => item.toString().contains('2019')).toList();
    // print(files[0].toString().contains('20190929_'));
    // files = files.where((item)=> item.startsWith('20190929_')).toList();
    // print(files);
    var dateList = [];
    for (var i = 0; i < files.length; i++) {
      dateList.add(files[i].toString().split('/')[4].substring(0, 8));
    }
    dates = dateList.toSet().toList();

    setState(() {}); //update the UI
  }

  void getDateFromFiles() async {
    var dateList = [];
    print('files_all = $files.length');
    for (var i = 0; i < files.length; i++) {
      dateList.add(files[i].toString().split('/')[4].substring(0, 8));
    }
    dates = dateList.toSet().toList();
    print(dates);
    setState(() {}); //update the UI
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: files == null
          ? Text("Searching Files")
          : SafeArea(
              child: Column(children: [
                Row(
                  children: [
                    Button(dates[0]),
                    Button(dates[1]),
                    Button(dates[2]),
                    Button(dates[3]),
                    Button(dates[4]),
                  ],
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Button(dates[5]),
                    Button(dates[6]),
                    Button(dates[7]),
                    Button(dates[8]),
                    Button(dates[9]),
                  ],
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                )
              ]),
            ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/second');
      }),
    );
  }
}
