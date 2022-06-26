
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'dart:io';
import 'package:ml_dataframe/ml_dataframe.dart';


class ImageCollector {

  var files;
  var files_string;
  var files_all;
  var files_filtered;
  var dates;

  ImageCollector() {
    this.init();
    // this.getDateFromFiles();
  }

  void init() async {
    this.getAllFiles();
    DataFrame df = DataFrame([files_all]);
    print("df: $df");
  }


  void getAllFiles() async {
    var root = '/sdcard/DCIM/Camera';
    var fm = FileManager(root: Directory(root));
    print('files_all = $files_all.length');
    files_all = await fm.filesTree(
      //   excludedPaths: ["/storage/emulated/0/Android"],
        extensions: [
          "png",
          "jpg"
        ] //optional, to filter files, remove to list all,
    );
    files_all =  files_all.where((item) => item.toString().contains('2019')).toList();
    print("files all $files_all");

  }


}


class ImagesSortByDate {

  ImagesSortByDate(String date) {

  }

}

class ImagesSortByTime{

}

class ImagesSortByMonth{

}