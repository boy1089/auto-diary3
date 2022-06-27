import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io';
import 'package:ml_dataframe/ml_dataframe.dart';

// TODO : sort image. by year, by month, by date
// TODO : get all files, --> filesAll
//TODO : sort filesSortByYear, filesSortByMonth, filesSortByDate

//TODO : class - get files, def so

class Images {
  List<File> filesAll = [];
  List<String> years = [];
  List<String> months = [];
  List<String> dates = [];

  Images() {
    getFiles();
    years = getYearFromFiles();
    months = getMonthFromFiles();
    dates = getDateFromFiles();
  }

  void updateState() {
    getFiles();
    years = getYearFromFiles();
    months = getMonthFromFiles();
    dates = getDateFromFiles();
    print('$years, $months, $dates');
  }

  // List<File> getFilesAll() {return filesAll;}
  // List<String> getYears() {return years;}
  // List<String> getMonths() {return years;}
  // List<String> getDates() {return years;}

  void getFiles() async {
    //asyn function to get list of files
    // List<StorageInfo> storageInfo = await PathProvider.getStorageInfo();
    // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    var root = '/sdcard/DCIM/Camera';
    var fm = FileManager(root: Directory(root)); //
    filesAll = await fm.filesTree(extensions: [
      "png",
      "jpg"
    ] //optional, to filter files, remove to list all,
        );

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
          .add(filesAll[i].toString().split('/')[4].substring(0, 4));
    }
    return yearFromFilename.toSet().toList();
  }

  List<String> getMonthFromFiles() {
    List<String> monthFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      monthFromFilename
          .add(filesAll[i].toString().split('/')[4].substring(0, 6));
    }
    return monthFromFilename.toSet().toList();
  }

  List<String> getDateFromFiles() {
    List<String> dateFromFilename = [];
    for (int i = 0; i < filesAll.length; i++) {
      dateFromFilename
          .add(filesAll[i].toString().split('/')[4].substring(0, 8));
    }
    return dateFromFilename.toSet().toList();
  }
}
