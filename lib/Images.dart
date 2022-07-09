import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as Image;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';
// TODO : sort image. by year, by month, by date
// TODO : get all files, --> filesAll
//TODO : sort filesSortByYear, filesSortByMonth, filesSortByDate

//TODO : class - get files, def so

class Images {

  List<File> filesAll = [];
  List<File> filesAll_Camera = [];

  List<String> years = [];
  List<String> months = [];
  var datesRange;
  var dates;

  List<String> numberOfFiles = [];

  Images() {
    debugPrint('Image instance is created');
    updateState();
  }

  var permissionGranted = false;

  // final date;

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      permissionGranted = true;
    }
  }

  void updateState() async {
    debugPrint('Image class : getting files from app folder');
    filesAll = await getFiles();
    debugPrint('Image class : getting files from app folder : done, $filesAll');
    debugPrint('Image class : getting files from camera folder');
    getFilesFromCamera();
    debugPrint('Image class : getting files from camera folder : done');

    years = getYearFromFiles(filesAll);
    months = getMonthFromFiles(filesAll);
    dates = getDateFromFiles(filesAll);
    numberOfFiles = getNumberOfFiles(dates);
    datesRange = getDateRange(filesAll);

    debugPrint('image class : datesRange : $datesRange');
    debugPrint('Image class : dates are collected : $years, $months, $dates');
    debugPrint('Image class : number of files : $numberOfFiles');

    filesAll = List.from(filesAll.reversed);
    dates = List.from(dates.reversed);
    numberOfFiles = List.from(numberOfFiles.reversed);
    datesRange = List.from(datesRange.reversed);
    // List<String> reverseOrder (List<String> list) async {
    //   return List.from(list.reversed);
    // }
    //

  }

  void printStatus() {
    debugPrint("Image class, filesAll : $filesAll");
    debugPrint("Image class, years : $years");
    debugPrint("Image class, months : $months");
    debugPrint("Image class, dates : $dates");
    debugPrint("Image class, number of files : $numberOfFiles");
    debugPrint('image class : datesRange : $datesRange');
  }

  Future<List<File>> getFiles() async {
    var fm = FileManager(root: Directory(await _localPath));
    var b;
    b = fm.filesTree(extensions: [
      // "png",
      "jpg"
    ]);
    return b;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<File>> getFilesFromCamera() async {
    var kRoot = '/sdcard/DCIM/Camera';
    var fm = FileManager(root: Directory(kRoot)); //
    var b;
    b = fm.filesTree(extensions: [
      "png",
      "jpg"
    ] //optional, to filter files, remove to list all,
        );

    filesAll_Camera = await b;
    return b;
  }
  //

  void convertPngToJpg() async {
    int totalNumberofFiles = filesAll_Camera.length;

    for (int i = 0; i < filesAll_Camera.length; i++) {
      final path = await _localPath;
      var file_name = filesAll_Camera[i].toString().split('/').last.substring(
          0, filesAll_Camera[i].toString().split('/').last.length - 1);
      print(file_name);
      File file = await new File('$path/$file_name');

      if (await file.exists() == true) {
        print('exists!');
        continue;
      }

      final image =
          await Image.decodeImage(filesAll_Camera[i].readAsBytesSync())!;
      final thumbnail = Image.copyResize(image, width: 300);

      print('processing $i / $totalNumberofFiles th image : $path, $file');
      file.writeAsBytesSync(Image.encodePng(thumbnail));
    }
  }

  List<File> sortFilesByDate(String date) {
    var filesSortByDate;
    filesSortByDate =
        filesAll.where((item) => item.toString().contains('$date')).toList();

    return filesSortByDate;
  }

  List<String> getYearFromFiles(filesAll) {
    List<String> yearFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      yearFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 4));
    }
    return yearFromFilename.toSet().toList();
  }

  List<String> getMonthFromFiles(filesAll) {
    List<String> monthFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      monthFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 6));
    }

    return monthFromFilename.toSet().toList();
  }

  List<String> getDateFromFiles(filesAll) {
    List<String> dateFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      dateFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 8));
    }

    return dateFromFilename.toSet().toList();
  }

  List<String> getNumberOfFiles(List<String> dates) {
    List<String> numberOfFiles = [];
    for (int i = 0; i < dates.length; i++) {
      numberOfFiles.add(sortFilesByDate(dates[i]).length.toString());
    }
    return numberOfFiles;
  }

  List<String> getDateRange(filesAll){

    List<String> dateFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      dateFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 8));
    }

    var dates_temp = dateFromFilename.toSet().toList();

    var date_start = DateTime.parse(dates_temp.first);
    var date_end = DateTime.parse(dates_temp.last);
    var days;
    final daysToGenerate = date_end.difference(date_start).inDays;
    days = List.generate(daysToGenerate+1, (i) => DateTime(date_start.year, date_start.month, date_start.day + (i)));
    days = List.generate(days.length, (i) => DateFormat('yyyyMMdd').format(days[i]));

    return days;


    return dates;
  }
}
