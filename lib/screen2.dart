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
  var df_locations_hours;
  var df_locations_locations_forTimeline;

  var locations;
  var images;
  void getTimefromFilename() {
    var date = this.date.toString();
    debugPrint(
        'screen2 : getTimefromFilename date : $date, files : $files_images,');
    // debugPrint("screen2 : getTimefromFilename : $date");

    files_images =
        files_images.where((item) => item.toString().contains(date)).toList();
    debugPrint("screen2 : getTimefromFilename : files_images : $files_images");

    for (int i = 0; i < files_images.length; i++) {
      var time = files_images[i].toString().split('_').last.substring(0, 6);
      debugPrint("screen2 : getTimeFromFilename : time : $time");
      timesOfFiles.add(time);
      debugPrint("$i");
    }
    debugPrint('time : $timesOfFiles');
    // setState(() {}); //update the UI
  }


  @override
  void initState() {
    super.initState();
  }

  void updateStatus(dates, images, locations) async {
    this.date = dates;
    files_images = [];
    List<String> timesOfFiles = [];
    files_images = images.filesAll;
    getTimefromFilename();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as Map;
    var dates = arguments.toString().split(' ')[1].substring(0, 8);
    images = arguments['images'];
    locations = arguments['locations'];
    updateStatus(dates, images, locations);

    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          // Navigator.pushNamed(context, '/home');
          setState(() {debugPrint(locations.df_date);});
        }),
        appBar:
            AppBar(title: Text("$dates"), backgroundColor: Colors.redAccent),
        // body: (files_images == null || df_locations_locations_forTimeline == null)
        body: (files_images == null)
            ? Text("Searching Files")
            : Row(
                children: [
                  SizedBox(width: kLeftGap),
                  Column(children: [TimelineContainerList(ktimeline)]),
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

  Widget TimelineContainerList(List ktimeline) {
    return Column(
        children: List.generate(ktimeline.length, (index) {
          return TimelineContainer(
              kTimelineWidth, kTimelineHeight / ktimeline.length, index);
        }));
  }

  Widget TimelineContainer(double width, double height, index) {
    var time = ktimeline[index];
    // df_locations.colRords<DateTime>('time').hour = int.parse(time)];
    // print("screen2 : TimeLineContainer : length of Colors : ${kColorsForLocations.length}, index : $index");

    var aa = locations.index_for_plot_date;
    print((locations.latitude_date[aa[index]] - kLatitudeMin)*300);
    print(((locations.longitude_date[aa[index]] - kLongitudeMin)*300/ (kLongitudeMax- kLongitudeMin)).round());

    return Container(
      width: width,
      height: height,
      child: Text("$time"),
      decoration: BoxDecoration(
          // color: Colors.red,
          color : Color.fromARGB(150, ((locations.latitude_date[aa[index]] - kLatitudeMin)*400).round(),
              200,
              ((locations.longitude_date[aa[index]] - kLongitudeMin)*400).round()
              ),
          // // Color.fromARGB(
          //     min(255, int.parse(numberOfFiles) * 3), 200, 100, 100),
          shape: BoxShape.rectangle,
          borderRadius: index == 0
              ? BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))
              : null),
    );
  }

  Widget ImageRow(String time, List<File> fileList, List<String> times) {
    var indexOfImagewithSpecificTime = [];

    for (int i = 0; i < times.length; i++) {
      if (times[i].startsWith(time)) {
        indexOfImagewithSpecificTime.add(i);

      }
    }


    return Row(
        children : indexOfImagewithSpecificTime.length != 0
            ? List.generate(indexOfImagewithSpecificTime.length, (index) {
          debugPrint("time, $time, row created");
          return Image.file(
            fileList[indexOfImagewithSpecificTime[index]],
            height: kImageHeight,
            width: kImageWidth,
          );})
            : [SizedBox(height : kImageHeight)]);




  }

}
