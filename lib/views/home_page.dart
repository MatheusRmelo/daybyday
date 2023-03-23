import 'package:daybyday/models/day.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/widgets/day_card.dart';
import 'package:daybyday/views/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> _days = [];
  int _active = 0;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      _days.add(
          DateTime(today.year, today.month, (today.day - today.weekday) + i));
      _active = today.weekday - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dominant,
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 8),
            margin: const EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.8))),
            child: _days.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateFormat("d 'de' MMMM").format(_days.first)} até ${DateFormat("d 'de' MMMM").format(_days.last)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.date_range,
                            color: AppColors.textNormal,
                          )),
                    ],
                  ),
          ),
          const NotificationCard(
              title: 'Notificação', message: "Hora de se exercitar"),
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 24),
            child: ListView.builder(
              itemCount: _days.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  DayCard(isActive: index == _active, date: _days[index]),
            ),
          )
        ]),
      ),
    );
  }
}
