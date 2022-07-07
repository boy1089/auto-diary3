
import 'package:intl/intl.dart';

class Dates {

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