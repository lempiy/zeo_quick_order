Map<String, String> httpMonths = {"Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04", "May": "05", "Jun": "06", "Jul": "07", "Aug": "08", "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"};
RegExp httpDate = RegExp(r"^[A-Za-z]{3}\,\s([0-9]{1,2})\s([A-Za-z]{3})\s([0-9]{4})\s([0-9:]{8})\sGMT$");

DateTime parseHttpDate(String v) {
  RegExpMatch match = httpDate.firstMatch(v);
  if (match == null) return null;
  String date = _leadingZero(match.group(1));
  String month = httpMonths[match.group(2)];
  String year = match.group(3);
  String time = match.group(4);

  return DateTime.parse("$year-$month-$date${"T"}$time${"Z"}");
}

String _leadingZero(String v) {
  if (v.length == 2) return v;
  return "0" + v;
}
