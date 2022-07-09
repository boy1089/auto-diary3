import 'dart:convert' show utf8;
// import 'dart:html';
import 'dart:io';

import 'package:df/df.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter/foundation.dart';
// import 'package:ml_dataframe/ml_dataframe.dart';


class Locations {
  List<int> mostFrequentLocation = [];

  var path_location = '/location';
  var path;
  var filesAll;
  var dates;
  var freqLocations;
  var setOfLocations;

  Locations() {
    print('location instance is under construction');
    updateState();
    print('location instance update done');
  }

  void updateState() async {
    debugPrint('location instance, getFiles started');
    filesAll = await getFiles();
    debugPrint('location instance : getFiles done : $filesAll');
    dates = await getDateFromFiles(filesAll);
    debugPrint('location instance : getDateFromFiles done : $dates');
    freqLocations = await getMostFrequentlocationAllDate(dates);
    debugPrint('location instance : getMostFreq~ done : $freqLocations');

    filesAll = List.from(filesAll.reversed);
    dates = List.from(dates.reversed);
    freqLocations = List.from(freqLocations.reversed);

  }

  void printStatus() {
    debugPrint("Locaiton instance : filesAll : $filesAll");
    debugPrint("Locaiton instance : dates : $dates");
    debugPrint("Locaiton instance : freqLocations : $freqLocations");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path + path_location;
    return path;
  }

  Future<DataFrame> readCsv(String path) async {
    final df = await DataFrame.fromCsv(path);
    return df;
  }

  Future<List<File>> getFiles() async {
    var a = await _localPath;
    var kRoot = a;
    var fm = FileManager(root: Directory(kRoot)); //
    var b;
    b = fm.filesTree(extensions: ["csv"]);
    return b;
  }

  Future<List<String>> getMostFrequentlocationAllDate(dates) async {
    List<String> freqLocationList = [];

    print('location, getMostFreq~~AllDate, $dates');

    for (int i = 0; i < dates.length - 1; i++) {
      // print('getMost $i / ${dates.length}');
      String freqLocation = await getMostFrequentLocation(filesAll[i].path);
      freqLocationList.add(freqLocation);
    }
    return freqLocationList;
  }

  // Future<Map<String, int>> getMostFrequentLocation(String path) async {
  Future<String> getMostFrequentLocation(String path) async {
    var df = await readCsv(path);
    var locations = df.colRecords<String>('address');
    setOfLocations = locations.toSet().toList();

    Map<String, int> counts = {};
    for (int i = 0; i < setOfLocations.length; i++) {
      var count = locations.where((c) => c == setOfLocations[i]).length;
      counts[setOfLocations[i]] = count;
    }

    counts = Map.fromEntries(counts.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));

    // var a = counts[counts.keys.first];
    // print('counts acquired : $counts');
    counts.removeWhere((key, value) => key == counts.keys.last);

    return counts.keys.last;
  }

  void getSetofLocations(String path) async {
    var df = await readCsv(path);
    var locations = df.colRecords<String>('address');
    setOfLocations = locations.toSet().toList();
  }

  List<String> getDateFromFiles(filesAll) {
    List<String> dateFromFilename = [];
    debugPrint('location, getDateFromFiles, $filesAll');
    for (int i = 0; i < filesAll.length; i++) {
      dateFromFilename.add(filesAll[i]
          .toString()
          .split('/')
          .last
          .substring(0, 10)
          .replaceAll('-', ''));
    }
    // dates =
    return dateFromFilename.toSet().toList();
  }
  List<dynamic> getFilefromDate(String date){
     return filesAll.where((item) => item.toString().contains(date)).toList();

  }

  Future<DataFrame> readCsv2(String path) async {
    // var df = await readCsv(path);
    // var locations = df.colRecords<String>('address');
    // var time = df.colRecords<DateTime>('Time');
    return await readCsv(path);
    // return [time, locations];
  }
}
