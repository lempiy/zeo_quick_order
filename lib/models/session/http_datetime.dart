import 'dart:io';

Map<String, String> WeekDays = {
  "Mon": "Monday",
  "Tue": "Tuesday",
  "Wed": "Wednesday",
  "Thu": "Thursday",
  "Fri": "Friday",
  "Sat": "Saturday",
  "Sun": "Sunday"
};
RegExp httpDate = RegExp(
    r"^[A-Za-z]{3}\,\s([0-9]{1,2})\s([A-Za-z]{3})\s([0-9]{4})\s([0-9:]{8})\sGMT$");

DateTime parseHttpDate(String v) {
  String weekDay = v.substring(0, 3);
  v = v.replaceFirst(v.substring(0, 3), WeekDays[weekDay]);
  return HttpDate.parse(v);
}
