import 'package:intl/intl.dart';

convertDateToString(DateTime date) {
  return '${DateFormat('dd.MM.yyyy, HH:mm').format(date)} Uhr';
}
