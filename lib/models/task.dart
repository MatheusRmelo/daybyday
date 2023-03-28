import 'category.dart';

class Task {
  String id;
  String name;
  bool isComplete;
  Category category;

  Task(
      {this.id = '',
      required this.name,
      required this.isComplete,
      required this.category});

  Task.fromJson(Map<String, dynamic> json, {required String doc})
      : id = doc,
        name = json['name'],
        isComplete = json['is_complete'],
        category = Category.values
            .firstWhere((element) => json['category'] == element.name);

  Map<String, dynamic> toJson() =>
      {'name': name, 'is_complete': isComplete, 'category': category.name};
}
