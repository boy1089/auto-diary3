// import 'dart:html';

import 'package:auto_diary3/LocationLogger.dart';
import 'package:flutter/material.dart';
import 'package:auto_diary3/Images.dart';
import 'dart:math';
import 'package:auto_diary3/LocationLogger.dart';
import 'package:auto_diary3/Locations.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var images;
  var files_image;
  var dates_image;
  var numberOfFiles_image;


  var locationLogger;
  var locations;
  var dates_location;
  var files_location;
  var freqLocations_location;

  int screenIndex = 0;
  List<Widget> screenList = [Text('home'), Text('setting')];

  void initState() {
    // getFiles(); //call getFiles() function on initial state.
    super.initState();

    init();
    print("files : $files_image");
    setState(() {});
  }

  void init() async {
    images = Images();
    locationLogger = LocationLogger();
    locations = Locations();
    var c;
    c = await images.getFiles();
    files_image = await images.filesAll;
    dates_image = await images.getDateFromFiles();
    numberOfFiles_image = await images.getNumberOfFiles(dates_image);


    c = await locations.getFiles();
    files_location = await locations.filesAll;
    dates_location = await locations.getDateFromFiles();
    freqLocations_location = await locations.getMostFrequentlocationAllDate();
    print(freqLocations_location);


    print('dates_image : $dates_image');
    print('dates_location : $dates_location');
    setState(() {});
  }

  Widget Button(String text, String numberOfFiles, String location) {
    var date = text.substring(4, 8);
    var color = '2F1BDB';
    return Container(
      // flex: 2,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(
            min(255, int.parse(numberOfFiles) * 3), 200, 100, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(5),
        height: 20,
        child: Text("$date, $numberOfFiles,$location", style: TextStyle(fontSize: 8)),
        onPressed: () {
          Navigator.pushNamed(context, '/second', arguments: {'date': text});
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: files_image == null
            ? Text("Searching Files")
            : SafeArea(
                minimum: EdgeInsets.all(40),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: dates_image.length,
                    // itemCount: 2,

                    itemBuilder: (context, index) {
                      return Button(
                        dates_image[index],
                        numberOfFiles_image[index],
                        freqLocations_location[index],
                        // 'aa',

                      );
                    }),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex : screenIndex,
          items : [
            BottomNavigationBarItem(icon: Icon(Icons.home), label : 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label : 'setting'),

          ],
            onTap : (value){
            setState((){
              if(value ==1) Navigator.pushNamed(context, '/setting');
              if(value ==0) Navigator.pushNamed(context, '/home');
              print('$value');
            });
      }
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {

          // images.convertPngToJpg();
          var files_location = await locations.getFiles();
          print("file_location : $files_location");
          print(files_location[1].path);
          // locations.readCsv(files_location[0].path);
          locations.updateState();
          locations.getMostFrequentLocation(files_location[2].path);

          // locations.print();
          // print(locations.path);
          // var a;
          // a = locationLogger.getCurrentLocation();
          // images.updateState();
          // setState(() {
          //   dates = images.dates;
          //   numberOfFiles = images.numberOfFiles;
          // });
        }),
      ),
    );
  }
}
