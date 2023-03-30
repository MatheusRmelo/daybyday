import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/category.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/models/week.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
import 'package:daybyday/utils/extensions/week_extension.dart';
import 'package:daybyday/utils/formats/date_format.dart';
import 'package:flutter/material.dart';

class TaskController extends ChangeNotifier {
  CollectionReference<Task>? _taskCollection;
  DateTime _activeDay = DateTime.now();
  Task? task;
  List<Task> _activeTasks = [];
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  List<Task> get activeTasks => _activeTasks;
  DateTime get activeDay => _activeDay;

  set activeDay(DateTime date) {
    _activeDay = date;
    _activeTasks = _tasks.getTasksInDay(date);
    notifyListeners();
  }

  void initDay({required Week week}) {
    _activeDay = week.initDay;
    _activeTasks = _tasks.getTasksInDay(_activeDay);
  }

  Future<void> setCollection(Week week) async {
    _taskCollection = FirebaseFirestore.instance
        .collection('weeks')
        .doc(week.id)
        .collection('tasks')
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromJson(snapshot.data()!, doc: snapshot.id),
            toFirestore: (value, options) => value.toJson());
    await get();
  }

  void activeTasksByDay(DateTime day, {bool notify = true}) {
    _activeTasks = tasks.getTasksInDay(day);
    if (notify) {
      notifyListeners();
    }
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
      _activeTasks = _tasks.getTasksInDay(_activeDay);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> update(Task task,
      {String? name, DateTime? day, bool? isComplete}) async {
    if (_taskCollection == null) return;
    int index = _tasks.indexWhere((element) => element.id == task.id);
    if (index == -1) return;

    var data = task.toUpdate(day: day, isComplete: isComplete);
    await _taskCollection!.doc(task.id).update(data);
    _tasks[index].updateFields(data);
    _activeTasks = _tasks.getTasksInDay(_activeDay);
    notifyListeners();
  }

  Future<void> destroy(Task task) async {
    if (_taskCollection == null) return;
    int index = _tasks.indexWhere((element) => element.id == task.id);
    if (index == -1) return;
    await _taskCollection!.doc(task.id).delete();
    _tasks.removeAt(index);
    _activeTasks = _tasks.getTasksInDay(_activeDay);
    notifyListeners();
  }

  Future<void> updatePriorities() async {
    for (int i = 0; i < _activeTasks.length; i++) {
      int index = _tasks.indexWhere((element) => element.id == tasks[i].id);
      if (index == -1) return;
      _tasks[index].priority = i;
      await _taskCollection!.doc(tasks[i].id).update({'priority': i});
    }
  }
}
