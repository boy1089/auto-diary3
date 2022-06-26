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
  List<String> times = [];
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

    // times = files.where((item)=>item.toString().split('_')[-1].substring(0, 6)).toList();
    for (int i = 0; i < files.length; i++) {
      var time = files[i].toString().split('_')[1].substring(0, 6);
      times.add(time);
      // times.add(files[0]);
      // print(files.length);
      print(i);
    }
    print('time : $times');
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
                  Column(children: [TimelineContainerList(ktimeline)]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(ktimeline.length, (index) {
                      return ImageRow(
                          ktimeline[index].toString(), files, times);
                    }),
                  )
                ],
              ));
  }
}

Widget TimelineContainerList(List timeline) {
  return Column(
      children: List.generate(timeline.length, (index) {
    return TimelineContainer(
        int.parse(timeline[index]) > 13 ? Colors.blue : Colors.red,
        kTimelineWidth,
        kTimelineHeight / timeline.length,
        index);
  }));
}

Widget TimelineContainer(Color color, double width, double height, index) {
  var time = ktimeline[index];
  return Container(
// flex: 2,
    width: width,
    height: height,
    child: Text("$time"),
    decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: index == 0
            ? BorderRadius.only(
                topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))
            : null),
  );
}

Widget ImageRow(String time, List<File> fileList, List<String> times) {
  // print(fileList);
  // print(times);
  var list = [];

  for (int i = 0; i < times.length; i++) {
    if (times[i].startsWith(time)) {
      list.add(i);
      print('$time, $i added');
    }
  }

  return Row(
      children: list.length != 0
          ? List.generate(list.length, (index) {
              return Image.file(fileList[list[index]],
                  height: kImageHeight, width: kImageWidth);
            })
          : [SizedBox(height: kImageHeight)]);
}
