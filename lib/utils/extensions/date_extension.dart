extension DateExtension on DateTime {
  bool get isToday {
    DateTime today = DateTime.now();
    return day == today.day && month == today.month && year == today.year;
  }

  bool isSameDay(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  SelectedWeek get startAndEndWeek {
    List<DateTime> daysInWeek = [];
    for (int i = 1; i <= 7; i++) {
      daysInWeek.add(DateTime(year, month, (day - weekday) + i));
    }
    return SelectedWeek(start: daysInWeek.first, end: daysInWeek.last);
  }
}

class SelectedWeek {
  DateTime start;
  DateTime end;

  SelectedWeek({required this.start, required this.end});
}
