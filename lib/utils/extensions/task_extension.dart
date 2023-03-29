import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';

extension TaskExtensionDays on List<Task> {
  List<Task> getTasksInDays(DateTime day) {
    sort((a, b) => a.priority - b.priority);
    return where((element) =>
        element.day.isNotEmpty &&
        DateTime.parse(element.day).isSameDay(day)).toList();
  }

  List<Task> get notAlocatedTasks =>
      where((element) => element.day.isEmpty).toList();
}
