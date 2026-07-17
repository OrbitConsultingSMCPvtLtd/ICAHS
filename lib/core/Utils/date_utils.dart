import 'package:intl/intl.dart';

String formatDateToDDMMMMYYYY(String date) {
  var formatter = DateFormat('dd MMMM y');
  return formatter.format(DateTime.parse(date));
}
