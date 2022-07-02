import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';
import 'package:auto_diary3/util.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}

var filesAll;
Future<List<File>> getFiles() async {
  //asyn function to get list of files
  // List<StorageInfo> storageInfo = await PathProvider.getStorageInfo();
  // var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
  // var kRoot = '/sdcard/DCIM/Camera';
  print(kRoot);
  var fm = FileManager(root: Directory(kRoot)); //
  var b;
  b = fm.filesTree(extensions: [
    "png",
    "jpg"
  ] //optional, to filter files, remove to list all,
  );
  // var filesAll;
  filesAll = await b;
  return b;
}
void decodeIsolate(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  var image = decodeImage(param.file.readAsBytesSync())!;
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  var thumbnail = copyResize(image, width: 120);
  param.sendPort.send(thumbnail);
}

// Decode and process an image file in a separate thread (isolate) to avoid
// stalling the main UI thread.
void main() async {
  var receivePort = ReceivePort();

  await Isolate.spawn(
      decodeIsolate, DecodeParam(File('test.webp'), receivePort.sendPort));

  // Get the processed image from the isolate.
  var image = await receivePort.first as Image;

  await File('thumbnail.png').writeAsBytes(encodePng(image));
}