import 'package:intl/intl.dart';

String formatDateToDDMMMMYYYY(String date) {
  var formatter = DateFormat('dd MMMM y');
  return formatter.format(DateTime.parse(date));
}

String? formatTime(String? time) {
  if (time == null) {
    return null;
  }

  var formatter = DateFormat.jm();
  return formatter.format(DateTime.parse(time));
}
