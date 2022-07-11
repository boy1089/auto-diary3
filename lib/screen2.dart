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

  void getTimefromFilename() {
    var date = this.date.toString();
    debugPrint('screen2 : getTimefromFilename date : $date, files : $files_images,');
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

  List<String> getLocationsForTimeline(df_locations){
    List<String> locationForTimeline = [];
    for(int i= 0; i<ktimeline.length; i++){
      for(int j= 0; j<df_locations_hours.length; j++){
        if(df_locations_hours[j] == int.parse(ktimeline[i])){
          locationForTimeline.add(df_locations.colRecords<String>('address')[j]);
        }
      }
    }
    return locationForTimeline;

  }

  @override
  void initState() {
    super.initState();
  }

  void updateStatus(dates, images, locations) async {
    this.date = dates;
    files_images = images.filesAll;
    getTimefromFilename();
    debugPrint("screen2, build, files_images.length : ${files_images.length}");
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
    df_locations_hours = List.generate(df_locations.length,
        (int index) => df_locations.colRecords<DateTime>('time')[index].hour);
    debugPrint("screen2, build, df_locations_hours : $df_locations_hours");
    // debugPrint("screen2, build, check hour : ${cc == int.parse('10')}");

    setOfLocations = df_locations.colRecords<String>('address').toSet();
    debugPrint("screen2, build, setOfLocations : $setOfLocations");
    // setState((){df_locations_hours = List.generate(df_locations.length,
    //         (int index) => df_locations.colRecords<DateTime>('time')[index].hour);
    // });
    df_locations_locations_forTimeline = getLocationsForTimeline(df_locations);

    setState((){});
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
        body: (files_images == null || df_locations_locations_forTimeline == null)
        // body: (files_images == null)

        ? Text("Searching Files")
            : Row(
                children: [
                  SizedBox(width: kLeftGap),
                  Column(children: [
                    TimelineContainerList(ktimeline, df_locations_locations_forTimeline)
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





  Widget TimelineContainerList(List ktimeline, df_locations_forTimeline) {
    return Column(
        children: List.generate(ktimeline.length, (index) {
          return TimelineContainer(kTimelineWidth, kTimelineHeight / ktimeline.length,
              index, df_locations_forTimeline);
        }));
  }

  Widget TimelineContainer(double width, double height, index, df_locations_forTimeline) {
    var time = ktimeline[index];
    // df_locations.colRecords<DateTime>('time')
    //
    // debugPrint("TimelineContainer : df_locations_hours : $df_locations_forTimeline");
    // for (int i = 0; i< df_locations_forTimeline.length; i++){
    //
    // }
    // for (int i = 0; i < ktimeline.length; i++) {debugPrint("screen2 : TimelineContainer : $i");}
    // print("screen2 : TimeLineContainer : $df_locations");
    // var df_locations_2 = df_locations[df_locations.colRecords<DateTime>('time').hour = int.parse(time)];
    print("screen2 : TimeLineContainer : length of Colors : ${kColorsForLocations.length}, index : $index");
    // var location = df_locations_2[0];
    // debugPrint("screen2 : TimeLineContainer : Location : $location");
    debugPrint("screen2 : TimeLineContainer : df_locations_forTimeline : $df_locations_forTimeline");

    return Container(
      width: width,
      height: height,
      child: Text("$time, ${df_locations_forTimeline[index]}"),
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

        debugPrint(
            'screen2, ImageRow, fileList : $fileList');
      }
    }

    debugPrint("screen2 : ImageRow : indexOfImage : $indexOfImagewithSpecificTime");

    return Row(
        children: indexOfImagewithSpecificTime==null
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






}
