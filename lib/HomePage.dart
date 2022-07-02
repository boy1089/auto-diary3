import 'package:flutter/material.dart';
import 'package:auto_diary3/Images.dart';
import 'dart:math';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var images;
  var files ;
  var dates;
  var numberOfFiles;


  void initState() {
    // getFiles(); //call getFiles() function on initial state.
    super.initState();

    init();
    print("files : $files");
    setState((){});

  }
  void init() async {
    images = Images();
    var c ;
    c = await images.getFiles();
    files = await images.filesAll;
    dates = await images.getDateFromFiles();
    numberOfFiles = await images.getNumberOfFiles(dates);

  setState(() {

      });
    print('after setState $numberOfFiles');
  }

  Widget Button(String text, String numberOfFiles) {
    var date = text.substring(4, 8);
    var color = '2F1BDB';
    return Container(
      // flex: 2,
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(min(255, int.parse(numberOfFiles)*3), 200, 100, 100),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(5),
        height: 20,
        child: Text("$date, $numberOfFiles",
          style: TextStyle(fontSize: 8)),
        onPressed: () {
          Navigator.pushNamed(context, '/second', arguments: {'date': text});
        },
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: files == null
          ? Text("Searching Files")
          : SafeArea(
            minimum: EdgeInsets.all(40),
             child: GridView.builder(
               physics : NeverScrollableScrollPhysics(),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 5,
                 crossAxisSpacing: 20,
                 mainAxisSpacing: 20,
               ),

               itemCount: dates.length,
               itemBuilder: (context, index){
                 return Button(
                   dates[index], numberOfFiles[index],
                 );}),

               ),


      floatingActionButton: FloatingActionButton(onPressed: () {
        images.convertPngToJpg();
        images.updateState();
        setState((){dates = images.dates;
        numberOfFiles = images.numberOfFiles;});
      })
      ,
    );
  }
}
