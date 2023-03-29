import 'package:daybyday/utils/formats/date_format.dart';

import 'category.dart';

class Task {
  String id;
  String name;
  String day;
  int priority;
  bool isComplete;
  Category category;

  Task(
      {this.id = '',
      this.day = '',
      this.priority = 10,
      required this.name,
      required this.isComplete,
      required this.category});

  Task.fromJson(Map<String, dynamic> json, {required String doc})
      : id = doc,
        name = json['name'],
        priority = json['priority'] ?? 0,
        isComplete = json['is_complete'],
        day = json['day'] ?? "",
        category = Category.values
            .firstWhere((element) => json['category'] == element.name);

  void updateFields(Map<String, dynamic> data) {
    if (data['day'] != null) {
      day = data['day'];
    }
    if (data['is_complete'] != null) {
      isComplete = data['is_complete'];
    }
  }

  Map<String, dynamic> toUpdate({DateTime? day, bool? isComplete}) {
    Map<String, dynamic> data = {};
    if (day != null) {
      data['day'] = AppDateFormat.toSave.format(day);
    }
    if (isComplete != null) {
      data['is_complete'] = isComplete;
    }
    return data;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'day': day,
        'priority': priority,
        'is_complete': isComplete,
        'category': category.name
      };
}
