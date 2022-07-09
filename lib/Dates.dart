
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_diary3/Images.dart';

import 'package:flutter/foundation.dart';
class Dates {
  var dates;
  Dates(Images images){
    debugPrint('dates initializing Dates');
    dates= getDateRange(images.dates.first, images.dates.last);
    debugPrint('dates initialization done ');

  }

  List<String> getDateRange(String start, String end){
  var date_start = DateTime.parse(start);
  var date_end = DateTime.parse(end);
  var days;
  final daysToGenerate = date_end.difference(date_start).inDays;
  days = List.generate(daysToGenerate+1, (i) => DateTime(date_start.year, date_start.month, date_start.day + (i)));
  days = List.generate(days.length, (i) => DateFormat('yyyyMMdd').format(days[i]));

  return days;

  }



}