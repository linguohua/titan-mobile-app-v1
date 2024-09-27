extension DateExtraction on String {
  String toDate() {
    try {
      final DateTime dateTime = DateTime.parse(this);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
