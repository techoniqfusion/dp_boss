import 'package:intl/intl.dart';

String extractDateFromDateTime(String date, String? newPattern) {
  final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final DateFormat serverFormatter = DateFormat(newPattern);
  final DateTime displayDate = displayFormatter.parse(date);
  final String formatted = serverFormatter.format(displayDate);
  return formatted;
}