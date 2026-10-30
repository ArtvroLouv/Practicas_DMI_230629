import 'package:intl/intl.dart';

class HumanFormats {
  static final _numberFormat = NumberFormat.compact(locale: 'en');

  static String number(double value) => _numberFormat.format(value);
}
