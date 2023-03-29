import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/category.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/models/week.dart';
import 'package:daybyday/utils/formats/date_format.dart';
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

  Future<void> get() async {
    if (_taskCollection == null) return;
    var snapshots = await _taskCollection!.get();
    _tasks = snapshots.docs.map((e) => e.data()).toList();
    notifyListeners();
  }

  Future<bool> store(String name, {DateTime? day}) async {
    Task task = Task(
        category: Category.other,
        isComplete: false,
        name: name,
        day: day != null ? AppDateFormat.toSave.format(day) : '');

    var reference = await _taskCollection!.add(task);
    var snapshot = await reference.get();
    if (snapshot.data() != null) {
      _tasks.add(snapshot.data()!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> update(Task task, {DateTime? day}) async {
    if (_taskCollection == null) return;
    int index = _tasks.indexWhere((element) => element.id == task.id);
    if (index == -1) return;

    var data = task.toUpdate(day: day);
    await _taskCollection!.doc(task.id).update(data);
    _tasks[index].updateFields(data);
    notifyListeners();
  }

  Future<void> updatePriorities(List<Task> tasks) async {
    for (int i = 0; i < tasks.length; i++) {
      int index = _tasks.indexWhere((element) => element.id == tasks[i].id);
      if (index == -1) return;
      _tasks[index].priority = i;
      await _taskCollection!.doc(tasks[i].id).update({'priority': i});
    }
  }
}
