import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:glob/glob.dart';
import 'package:auto_diary3/util.dart';

//apply this class on home: attribute at MaterialApp()
class MyFileList extends StatefulWidget {
  // var date;

  // MyFileList(var date){
  //   date = date;
  // }
  //
  final String date;
  MyFileList({required this.date});

  @override
  State<StatefulWidget> createState() {
    return _MyFileList(date);
  }
}

class _MyFileList extends State<MyFileList> {
  var date;
  _MyFileList(var date) {
    this.date = date;
  }
  // _MyFileList({Key key, @required this.date}) : super(key: key);

  var files;
  var permissionGranted = false;
  // final date;

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    }
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
        //remove this if your are grabbing folder list
        );

    // files = files.where((item)=> item.toString().contains('$date')).toList();

    var date = this.date.toString();
    files = files.where((item) => item.toString().contains('$date')).toList();
    // print(files[0].toString().contains('20190929_'));
    // files = files.where((item)=> item.startsWith('20190929_')).toList();

    print('$date, files : $files');
    setState(() {}); //update the UI
  }

  @override
  void initState() {
    _getStoragePermission();
    getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) ??
        <String, dynamic>{} as Map;
    var bb = arguments.toString().split(' ')[1].substring(0, 8);
    setState(() {
      this.date = bb;
    });
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.pushNamed(context, '/home');
        }),
        appBar: AppBar(title: Text("$bb"), backgroundColor: Colors.redAccent),
        body: files == null
            ? Text("Searching Files")
            : Row(
                children: [
                  SizedBox(width: kLeftGap),
                  Column(children: [
                   TimelineContainer(Colors.blue, kTimelineWidth, kTimelineHeight),
                    TimelineContainer(Colors.red, kTimelineWidth, kTimelineHeight),
                  ]),

                  Row(
                    children: [
                      Image.file(files[0],
                          height: kImageHeight, width: kImageWidth)
                    ],
                  ),
                  //
                  // Expanded(
                  //   child : ListView.builder(
                  //     itemCount: files?.length ?? 0,
                  //     itemBuilder: (context, index) {
                  //       return Card(
                  //           child: ListTile(
                  //             leading: Image.file(files[index]), //Icon(Icons.image),
                  //           ));
                  //     },
                  //   ),
                  // )
                ],
              ));
  }
}

Widget TimelineContainer(Color color, double width, double height) {
  return Container(
// flex: 2,
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
  );
}
