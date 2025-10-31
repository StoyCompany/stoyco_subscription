import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';

abstract final class StoycoDateFormatters {

  /// Formats a [DateTime] object as 'dd/MM/yyyy' (e.g. 10/11/2024).
  /// Returns 'Fecha no disponible' if [date] is null.
  static String formatDateAsDayMonthYear(DateTime? date) {
    if (date == null) {
      return 'Fecha no disponible';
    }
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
  }

  /// Formats an ISO 8601 date string as 'dd MMM yyyy' using Spanish month abbreviations.
  /// Returns the original string and logs an error if parsing fails.
  static String formatIso8601AsDayMonthAbbrYear(String isoDateString) {
    final DateTime? date = DateTime.tryParse(isoDateString);
    if (date != null) {
      final String month = getSpanishMonthAbbreviation(date.month);
      return '${date.day.toString().padLeft(2, '0')} $month ${date.year}';
    } else {
      StoyCoLogger.error(
        "Date couldn't be parsed: $isoDateString",
        stackTrace: StackTrace.current,
      );
      return isoDateString;
    }
  }

  /// Formats a [DateTime] as 'dd MMM. yyyy' (e.g. 10 oct. 2025).
  /// Returns 'Fecha no disponible' if [date] is null.
  static String formatDateAsDayMonthAbbrYear(DateTime? date) {
    if (date == null) {
      return 'Fecha no disponible';
    }
    return '${date.day.toString().padLeft(2, '0')} ${getSpanishMonthAbbreviation(date.month)}. ${date.year}';
  }

  /// Returns the Spanish abbreviation for the given [month] (1-12).
  static String getSpanishMonthAbbreviation(int month) {
    const List<String> months = <String>[
      '',
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return months[month];
  }
}
