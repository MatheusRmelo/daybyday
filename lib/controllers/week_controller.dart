import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/task.dart';
import 'package:flutter/material.dart';

class WeekController extends ChangeNotifier {
  final CollectionReference<Task> _tasksCollection = FirebaseFirestore.instance
      .collection('tasks')
      .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromJson(snapshot.data()!, id: '1'),
          toFirestore: (value, options) => value.toJson());
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  Future<void> getTasks(
      {required String startAt, required String endAt}) async {
    var snapshots = await _tasksCollection
        .where('user_id', isEqualTo: 'teste')
        .where('start_at', isEqualTo: startAt)
        .where('end_at', isEqualTo: endAt)
        .get();
    _tasks = snapshots.docs.map((element) => element.data()).toList();
    notifyListeners();
  }
}
