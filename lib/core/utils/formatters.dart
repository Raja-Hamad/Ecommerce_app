import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

class Formatters {
  Formatters._();

  static String currency(double amount) =>
      '${AppStrings.currencySymbol}${amount.toStringAsFixed(2)}';

  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  static String dateTime(DateTime date) => DateFormat('dd MMM, hh:mm a').format(date);
}
