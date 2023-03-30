import 'package:daybyday/models/week.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';

extension WeekExtension on Week {
  DateTime get initDay {
    int index = days.indexWhere((element) => element.isSameDay(DateTime.now()));
    if (index == -1) {
      return days.first;
    } else {
      return DateTime.now();
    }
  }
}
