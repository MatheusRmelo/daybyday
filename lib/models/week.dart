class Week {
  String id;
  String uid;
  String startAt;
  String endAt;
  List<DateTime> get days {
    DateTime date = DateTime.parse(startAt);
    List<DateTime> days = [];
    for (int i = 1; i <= 7; i++) {
      days.add(DateTime(date.year, date.month, (date.day - date.weekday) + i));
    }
    return days;
  }

  Week(
      {this.id = '',
      this.uid = '',
      required this.startAt,
      required this.endAt});

  Week.fromJson(Map<String, dynamic> json, {required String doc})
      : id = doc,
        uid = json['uid'],
        startAt = json['start_at'],
        endAt = json['end_at'];

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'start_at': startAt, 'end_at': endAt};
}
