import 'package:intl/intl.dart';

String getFormattedDate(String date, String formatString) {
  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
  DateTime dateTime = dateFormat.parse(date);
  return DateFormat(formatString).format(dateTime);
}

String getDay(String date) {
  return getFormattedDate(date, 'd');
}

String formatTime(String time) {
  return getFormattedDate(time, 'h:mm a');
}

String dateFromMilisecond(dynamic miliscnd,
    {String format = 'yyyy/MM/dd HH:mm:ss'}) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miliscnd);
  return DateFormat(format).format(dateTime);
}

String getWeekday(String date) {
  DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
  DateTime dateTime = dateFormat.parse(date);
  String fullWeekday = DateFormat('EEEE').format(dateTime);
  return fullWeekday.substring(0, 3);
}
