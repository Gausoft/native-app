import 'package:intl/intl.dart';

class DateUtils {
  static final _dateFormatter = DateFormat('dd/MM/yyyy');
  static final _timeFormatter = DateFormat('HHumm');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
  static String formatTime(DateTime date) => _timeFormatter.format(date);
}