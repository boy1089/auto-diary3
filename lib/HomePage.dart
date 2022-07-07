// import 'dart:html';

import 'package:auto_diary3/LocationLogger.dart';
import 'package:flutter/material.dart';
import 'package:auto_diary3/Images.dart';
import 'dart:math';
import 'package:auto_diary3/LocationLogger.dart';
import 'package:auto_diary3/Locations.dart';

import 'package:auto_diary3/Dates.dart';

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
  var dates_dates;
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
    dates = Dates();
    var c;
    c = await images.getFiles();
    files_image = await images.filesAll;
    dates_image = await images.getDateFromFiles();
    numberOfFiles_image = await images.getNumberOfFiles(dates_image);

    dates_image = List.from(dates_image.reversed);
    numberOfFiles_image = List.from(numberOfFiles_image.reversed);

    c = await locations.getFiles();
    files_location = await locations.filesAll;
    dates_location = await locations.getDateFromFiles();
    freqLocations_location = await locations.getMostFrequentlocationAllDate();

    dates_location = List.from(dates_location.reversed);
    freqLocations_location = List.from(freqLocations_location.reversed);

    dates_dates = dates.getDateRange(dates_image.last, dates_image[0]);

    dates_dates = List.from(dates_dates.reversed);

    print('dates_image : $dates_image');
    print('dates_location : $dates_location');
    print('dates_dates : $dates_dates');

    setState(() {});
  }

  Widget Button(String text, String numberOfFiles, String location) {

    var date = 'null';
    if(text != null){
      date = text.substring(4, 8);
      print('date : $date');
    }
    var color = '2F1BDB';
    return Container(
      // flex: 2,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: numberOfFiles == null? Colors.grey:Color.fromARGB(
            min(255, int.parse(numberOfFiles) * 3), 200, 100, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: date==null? null:FlatButton(
        padding: EdgeInsets.all(5),
        height: 20,
        child: Text("$date, $numberOfFiles,$location", style: TextStyle(fontSize: 8)),
        onPressed: () {
          Navigator.pushNamed(context, '/second', arguments: {'date': text});
        },
      ),
    );
  }
  int i_image = 0;
  int i_location = 0;

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: files_image == null
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
                    itemCount: dates_dates.length,
                    // itemCount : 10,

                    itemBuilder: (context, index) {
                      var button = Button(
                        dates_dates[index]==dates_image[i_image]? dates_image[i_image]: null,
                        // dates_dates[index]==dates_image[i_image-1]?  null: dates_image[i_image-1],
                        dates_dates[index]==dates_image[i_image]? numberOfFiles_image[i_image]: null,
                        dates_dates[index]==dates_location[i_location]? freqLocations_location[i_location]:null,
                      );
                      print('${dates_dates[index]}, ${dates_image[i_image]}');
                      if(dates_dates[index] == dates_image[i_image]){
                        // print('dates_Date and date_image is matched! $index, $i_image,  ${dates_dates[index]}, ${dates_image[i_image]}');
                        // print(dates_dates[index]==dates_image[i_image]);
                        i_image +=1;}

                      if(dates_dates[index] == dates_location[i_location]){
                        print('dates_Date and date_location is matched! $index, $i_location,  ${dates_dates[index]}, ${dates_location[i_location]}');
                        // print(dates_dates[index]==dates_location[i_image]);
                        i_location +=1;}

                      return button;
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

          images.convertPngToJpg();
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
