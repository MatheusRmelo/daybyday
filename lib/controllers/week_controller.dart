import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybyday/models/category.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/models/week.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekController extends ChangeNotifier {
  final String mockUID = 'teste';
  final CollectionReference<Week> _weekCollection = FirebaseFirestore.instance
      .collection('weeks')
      .withConverter<Week>(
          fromFirestore: (snapshot, options) =>
              Week.fromJson(snapshot.data()!, doc: snapshot.id),
          toFirestore: (value, options) => value.toJson());
  Week? _week;

  Week? get week => _week;

  List<DateTime> get currentWeek {
    DateTime today = DateTime.now();
    List<DateTime> days = [];
    for (int i = 1; i <= 7; i++) {
      days.add(
          DateTime(today.year, today.month, (today.day - today.weekday) + i));
    }
    return days;
  }

  Future<Week> get({String? startAt, String? endAt}) async {
    if (startAt == null || endAt == null) {
      startAt = DateFormat('yyyy-MM-dd').format(currentWeek.first);
      endAt = DateFormat('yyyy-MM-dd').format(currentWeek.last);
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
    notifyListeners();
    return _week!;
  }
}
