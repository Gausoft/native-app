import 'package:intl/intl.dart';

class DateUtils {
  static final _dateFormatter = DateFormat('dd/MM/yyyy');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
}