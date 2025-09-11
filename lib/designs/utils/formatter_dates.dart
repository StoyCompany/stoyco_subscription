/// Formats a DateTime as dd/MM/yyyy (e.g. 10/11/2024)
String formatDateDMY(DateTime? date) {
  if (date == null) {
    return 'Fecha no disponible';
  }
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day/$month/$year';
}
