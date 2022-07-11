// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:auto_diary3/Images.dart';
import 'dart:math';
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

  var dates;
  var datesRange_image;
  int screenIndex = 0;
  List<Widget> screenList = [Text('home'), Text('setting')];

  void initState() {
    // getFiles(); //call getFiles() function on initial state.

    init();
    // print("files : $files_image");
    print("init done on home page");

    setState(() {});
    super.initState();
  }

  void init() async {
    images = Images();
    // locationLogger = LocationLogger();
    locations = Locations();

    print('dates_dates : $images.dates');
    print('dates_image : $images.dates');
    print('dates_location : $locations.dates');
    print('numberOfFiles_image : $images.numberOfFiles');
    setState(() {});
  }

  Widget Button(String text, String numberOfFiles, String location) {
    var date = 'null';
    if (text != null) {
      date = text.substring(4, 8);
      print('date : $date');
    }
    var color = '2F1BDB';
    return Container(
      // flex: 2,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: numberOfFiles == null
            ? Colors.grey
            : Color.fromARGB(
                min(255, int.parse(numberOfFiles) * 3), 200, 100, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: date == null
          ? null
          : FlatButton(
              padding: EdgeInsets.all(5),
              height: 20,
              child: Text("$date, $numberOfFiles,$location",
                  style: TextStyle(fontSize: 8)),
              onPressed: () {
                Navigator.pushNamed(context, '/second', arguments: {
                  'date': text,
                  'images': images,
                  'locations': locations
                });
              },
            ),
    );
  }

  Widget build(BuildContext context) {
    int i_image = 0;
    int i_location = 0;
    return MaterialApp(
      home: Scaffold(
        body: images.dates == null
            ? Text("Searching Files")
            : SafeArea(
                minimum: EdgeInsets.all(30),
                child: GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    physics: AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    // itemCount: dates_image.length,
                    itemCount: images.datesRange.length,
                    // itemCount: 2,
                    itemBuilder: (context, index) {
                      debugPrint(
                          "HomePage, itembuilder, index : $index / ${images.datesRange.length}, image.dates : ${images.datesRange[index]}");
                      debugPrint(
                          "HomePage, itembuilder, i_imagej : $i_image, image.dates : ${images.dates[i_image]}");
                      var button = Button(
                        images.datesRange[index] == images.dates[i_image]
                            ? images.dates[i_image]
                            : null,
                        images.datesRange[index] == images.dates[i_image]
                            ? images.numberOfFiles[i_image]
                            : null,
                        images.datesRange[index] == locations.dates[i_location]
                            ? locations.freqLocations[i_location]
                            : null,
                      );
                      // print('${images.datesRange[index]}, ${images.dates[i_image]}');
                      if (images.datesRange[index] == images.dates[i_image]) {
                        // print('dates_Date and date_image is matched! $index, $i_image,  ${dates_dates[index]}, ${dates_image[i_image]}');
                        // print(dates_dates[index]==dates_image[i_image]);
                        i_image += 1;
                      }

                      if (images.datesRange[index] ==
                          locations.dates[i_location]) {
                        // print('dates_Date and date_location is matched! $index, $i_location,  ${images.dates[index]}, ${locations.dates[i_location]}');
                        // print(dates_dates[index]==locations.dates[i_image]);
                        i_location += 1;
                      }

                      return button;
                    }),
              ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: screenIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'setting'),
            ],
            onTap: (value) {
              setState(() {
                if (value == 1) Navigator.pushNamed(context, '/setting');
                if (value == 0) Navigator.pushNamed(context, '/home');
                print('$value');
              });
            }),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          setState(() {
            // images.printStatus();
            locations.printStatus();
            print(
                "images.dateRange.last : ${images.datesRange.last}, ${images.datesRange.length}");
            // locations.printStatus();
          });
          // images.convertPngToJpg();
          // var files_location = await locations.getFiles();
          // print("file_location : $files_location");
          // print(files_location[1].path);
          // // locations.readCsv(files_location[0].path);
          // locations.updateState();
          // locations.getMostFrequentLocation(files_location[2].path);

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
