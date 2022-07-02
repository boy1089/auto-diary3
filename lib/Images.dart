import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:auto_diary3/util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as Image;
import 'package:path_provider/path_provider.dart';
// import ''

// TODO : sort image. by year, by month, by date
// TODO : get all files, --> filesAll
//TODO : sort filesSortByYear, filesSortByMonth, filesSortByDate

//TODO : class - get files, def so

class Images {
  List<File> filesAll = [];
  List<String> years = [];
  List<String> months = [];
  var dates;

  List<String> numberOfFiles= [];
  Images() {
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
    getFiles();
    years = getYearFromFiles();
    months = getMonthFromFiles();
    dates = getDateFromFiles();
    numberOfFiles = getNumberOfFiles(dates);

    print('$years, $months, $dates');
    print('$numberOfFiles');
  }


  Future<List<File>> getFiles() async {
    //asyn function to get list of files
    // List<StorageInfo> storageInfo = await PathProvider.getStorageInfo();
    // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    // var kRoot = '/sdcard/DCIM/Camera';
    print(kRoot);
    // var fm = FileManager(root: Directory(kRoot)); //
    var fm = FileManager(root: Directory(await _localPath));
    var b;
    b = fm.filesTree(extensions: [
      "png",
      "jpg"
    ] //optional, to filter files, remove to list all,
        );

    filesAll = await b;
    print(filesAll);
    return b;
  }
  //
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  void convertPngToJpg() async {
    for(int i = 0; i<filesAll.length; i++){

      final image = await Image.decodeImage(filesAll[i].readAsBytesSync())!;
      final thumbnail = Image.copyResize(image, width: 300);
      final path = await _localPath;
      var file = filesAll[i].toString().split('/').last.substring(0, filesAll[i].toString().split('/').last.length - 1);
      print('processing $i th image : $path, $file');
      File('$path//$file').writeAsBytesSync(Image.encodePng(thumbnail));

    }

  }
  List<File> sortFilesByDate(String date) {
    var filesSortByDate;
    filesSortByDate =
        filesAll.where((item) => item.toString().contains('$date')).toList();

    return filesSortByDate;
  }

  List<String> getYearFromFiles() {
    List<String> yearFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      yearFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 4));
    }
    return yearFromFilename.toSet().toList();
  }

  List<String> getMonthFromFiles() {
    List<String> monthFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      monthFromFilename
          .add(filesAll[i].toString().split('/').last.substring(0, 6));
    }
    return monthFromFilename.toSet().toList();
  }

  List<String> getDateFromFiles() {
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
    print("numberOfFiles : $numberOfFiles");
    return numberOfFiles;
  }

}
