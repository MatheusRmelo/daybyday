import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/models/category.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/models/week.dart';
import 'package:daybyday/utils/extensions/week_extension.dart';
import 'package:daybyday/utils/formats/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeekController extends ChangeNotifier {
  final String mockUID = 'teste';
  final CollectionReference<Week> _weekCollection = FirebaseFirestore.instance
      .collection('weeks')
      .withConverter<Week>(
          fromFirestore: (snapshot, options) =>
              Week.fromJson(snapshot.data()!, doc: snapshot.id),
          toFirestore: (value, options) => value.toJson());
  DateTime _activeDay = DateTime.now();
  Week? _week;
  Week? get week => _week;
  DateTime get activeDay => _activeDay;
  List<DateTime> get currentWeek {
    DateTime today = DateTime.now();
    List<DateTime> days = [];
    for (int i = 1; i <= 7; i++) {
      days.add(
          DateTime(today.year, today.month, (today.day - today.weekday) + i));
    }
    return days;
  }

  set activeDay(DateTime date) {
    _activeDay = date;
    notifyListeners();
  }

  Future<Week> get(BuildContext context,
      {String? startAt, String? endAt}) async {
    if (startAt == null || endAt == null) {
      startAt = AppDateFormat.toSave.format(currentWeek.first);
      endAt = AppDateFormat.toSave.format(currentWeek.last);
    }

    var snapshots = await _weekCollection
        .where('uid', isEqualTo: mockUID)
        .where('start_at', isEqualTo: startAt)
        .where('end_at', isEqualTo: endAt)
        .get();
    if (snapshots.docs.isNotEmpty) {
      _week = snapshots.docs.first.data();
    } else {
      var reference = await _weekCollection
          .add(Week(uid: mockUID, startAt: startAt, endAt: endAt));
      _week = (await reference.get()).data();
    }
    // ignore: use_build_context_synchronously
    await context.read<TaskController>().setCollection(_week!);
    _activeDay = week!.initDay;
    notifyListeners();
    return _week!;
  }
}
