import 'dart:io';
import 'package:auto_diary3/Images.dart';
import 'package:flutter/material.dart';
import 'package:auto_diary3/util.dart';
import 'package:auto_diary3/Dates.dart';

import 'package:df/df.dart';
import 'package:auto_diary3/Locations.dart';

//apply this class on home: attribute at MaterialApp()
class MyFileList extends StatefulWidget {
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

  var files_images;
  var files_locations;
  List<String> timesOfFiles = [];
  var permissionGranted = false;
  var df_locations;
  var setOfLocations;

  void getTimefromFilename() {
    var date = this.date.toString();
    debugPrint('$date, files : $files_images,');
    files_images =
        files_images.where((item) => item.toString().contains(date)).toList();

    for (int i = 0; i < files_images.length; i++) {
      var time = files_images[i].toString().split('_').last.substring(0, 6);
      debugPrint("screen2 : getTimeFromFilename : time : $time");
      timesOfFiles.add(time);
      debugPrint("$i");
    }
    debugPrint('time : $timesOfFiles');
    setState(() {}); //update the UI
  }

  @override
  void initState() {
    super.initState();
  }

  void updateStatus(dates, images, locations) async {
    this.date = dates;
    files_images = images.filesAll;
    getTimefromFilename();
    debugPrint("screen2, build, 1");
    debugPrint("screen2, build, $dates");
    debugPrint("screen2, build, ${locations.getFilefromDate(dates)}");

    df_locations =
        await locations.readCsv2(locations.getFilefromDate(dates)[0].path);
    debugPrint("screen2, build, df_location : $df_locations");
    debugPrint(
        "screen2, build, df_location : ${df_locations.colRecords<String>('address')}");
    debugPrint(
        "screen2, build, df_location : ${df_locations.colRecords<DateTime>('time')}");
    debugPrint(
        "screen2, build, df_location : ${List.generate(df_locations.length, (int index) => df_locations.colRecords<DateTime>('time')[index].hour)}");
    var cc = List.generate(df_locations.length,
        (int index) => df_locations.colRecords<DateTime>('time')[index].hour);

    debugPrint("screen2, build, check hour : ${cc == int.parse('10')}");

    setOfLocations = df_locations.colRecords<String>('address').toSet();
    debugPrint("screen2, build, setOfLocations : $setOfLocations");
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as Map;
    var dates = arguments.toString().split(' ')[1].substring(0, 8);
    Images images = arguments['images'];
    Locations locations = arguments['locations'];
    updateStatus(dates, images, locations);

    setState(() {});


    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          // Navigator.pushNamed(context, '/home');
          setState(() {});
        }),
        appBar:
            AppBar(title: Text("$dates"), backgroundColor: Colors.redAccent),
        body: (files_images == null || df_locations == null)
            ? Text("Searching Files")
            : Row(
                children: [
                  SizedBox(width: kLeftGap),
                  Column(children: [
                    TimelineContainerList(ktimeline, df_locations)
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(ktimeline.length, (index) {
                      return ImageRow(ktimeline[index].toString(), files_images,
                          timesOfFiles);
                    }),
                  )
                ],
              ));
  }
}

Widget TimelineContainerList(List ktimeline, DataFrame df_locations) {
  return Column(
      children: List.generate(ktimeline.length, (index) {
    return TimelineContainer(kTimelineWidth, kTimelineHeight / ktimeline.length,
        index, df_locations);
  }));
}

Widget TimelineContainer(double width, double height, index, df_locations) {
  var time = ktimeline[index];
  // var bb = List.generate(df_locations.length, (int index) => df_locations.colRecords<DateTime>('time')[index].hour);

  for (int i = 0; i < ktimeline.length; i++) {}
  // var df_locations_temp = df_lo
  // var df_locations_2 = df_locations[df_locations.colRecords<DateTime>('time').hour = int.parse(time)];

  // var location = df_locations_2[0];
  // debugPrint("screen2 : TimeLineContainer : Location : $location");
  return Container(
    width: width,
    height: height,
    child: Text("$time"),
    decoration: BoxDecoration(
        color: kColorsForLocations[index],
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
  var indexOfImagewithSpecificTime = [];

  for (int i = 0; i < times.length; i++) {
    if (times[i].startsWith(time)) {
      indexOfImagewithSpecificTime.add(i);
      debugPrint(
          'screen2, ImageRow, time : $time, $i / ${times.length} , ${times[i]} added');
    }
  }

  debugPrint("$indexOfImagewithSpecificTime");

  return Row(
      children: indexOfImagewithSpecificTime.length != 0
          ? List.generate(indexOfImagewithSpecificTime.length, (index) {
              // return Image.file(fileList[list[index]],

              return Image.file(
                fileList[indexOfImagewithSpecificTime[index]],
                height: kImageHeight,
                width: kImageWidth,
              );
            })
          : [SizedBox(height: kImageHeight)]);
}
