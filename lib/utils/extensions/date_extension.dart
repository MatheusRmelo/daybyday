extension DateExtension on DateTime {
  bool get isToday {
    DateTime today = DateTime.now();
    return day == today.day && month == today.month && year == today.year;
  }

  bool isSameDay(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }
}
