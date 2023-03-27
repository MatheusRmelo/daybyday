import 'category.dart';

class Task {
  String id;
  String name;
  bool isComplete;
  Category category;

  Task(
      {required this.id,
      required this.name,
      required this.isComplete,
      required this.category});

  Task.fromJson(Map<String, dynamic> json, {required String id})
      : id = json['id'],
        name = json['name'],
        isComplete = json['is_complete'],
        category = Category.values
            .firstWhere((element) => json['category'] == element);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_complete': isComplete,
        'category': category.name
      };
}
