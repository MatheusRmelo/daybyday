import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';

extension TaskExtensionDays on List<Task> {
  List<Task> getTasksInDay(DateTime day) {
    sort((a, b) => a.priority - b.priority);
    sort((a, b) => a.isComplete ? 1 : -1);
    return where((element) =>
        element.day.isNotEmpty &&
        DateTime.parse(element.day).isSameDay(day)).toList();
  }

  List<Task> get notAlocatedTasks =>
      where((element) => element.day.isEmpty).toList();
}
