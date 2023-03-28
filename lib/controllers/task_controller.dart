import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/category.dart';
import 'package:daybyday/models/drag_day.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/models/week.dart';
import 'package:flutter/material.dart';

class TaskController extends ChangeNotifier {
  CollectionReference<Task>? _taskCollection;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void setCollection(Week week) {
    _taskCollection = FirebaseFirestore.instance
        .collection('weeks')
        .doc(week.id)
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromJson(snapshot.data()!, doc: snapshot.id),
            toFirestore: (value, options) => value.toJson());
    get();
  }

  List<DragDay> getDragDays() {
    return [
      DragDay(name: 'Não alocados', tasks: tasks),
      DragDay(name: 'Segunda', tasks: []),
    ];
  }

  Future<void> get() async {
    if (_taskCollection == null) return;
    var snapshots = await _taskCollection!.get();
    _tasks = snapshots.docs.map((e) => e.data()).toList();
    notifyListeners();
  }

  Future<bool> store(String name) async {
    Task task = Task(category: Category.other, isComplete: false, name: name);

    var reference = await _taskCollection!.add(task);
    var snapshot = await reference.get();
    if (snapshot.data() != null) {
      _tasks.add(snapshot.data()!);
      return true;
    }
    return false;
  }
}
