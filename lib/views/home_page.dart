import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/day.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
import 'package:daybyday/utils/extensions/week_extension.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:daybyday/views/widgets/day_card.dart';
import 'package:daybyday/views/widgets/notification_card.dart';
import 'package:daybyday/views/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    var controller = context.read<WeekController>();
    if (controller.week == null) {
      context.read<WeekController>().get(context).then((value) {
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeekController>(
        builder: (context, weekController, snapshot) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.dominant,
            elevation: 0,
            leadingWidth: 72,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.configDay);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border)),
                  child: Icon(Icons.app_registration,
                      color: AppColors.textNormal, size: 20),
                ),
              ),
            ),
            title: weekController.week != null
                ? Text(
                    "${DateFormat("d 'de' MMMM").format(weekController.week!.days.first)} até ${DateFormat("d 'de' MMMM").format(weekController.week!.days.last)}",
                    style: TextStyle(fontSize: 16, color: AppColors.textNormal),
                  )
                : const Text('Carregando...'),
            centerTitle: true,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CircleIconButton(
                    margin: EdgeInsets.zero,
                    icon: Icons.date_range,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.selectWeek);
                    }),
              )
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<TaskController>(
                  builder: (context, taskController, _) {
                if (taskController.tasks.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Você ainda não planejou essa semana",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              taskController.task = null;
                              Navigator.pushNamed(
                                  context, AppRoutes.plannigWeek);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: const Icon(Icons.add)),
                                const Text("Planejar semana"),
                              ],
                            )),
                      )
                    ],
                  );
                }

                return Column(children: [
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(top: 24, bottom: 16),
                    child: ListView.builder(
                      itemCount: weekController.week!.days.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => DayCard(
                          onPressed: () {
                            weekController.activeDay =
                                weekController.week!.days[index];
                          },
                          isActive: weekController.week!.days[index]
                              .isSameDay(weekController.activeDay),
                          date: weekController.week!.days[index]),
                    ),
                  ),
                  Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : taskController.tasks
                                  .getTasksInDay(weekController.activeDay)
                                  .isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Você ainda não alocou atividade para esse dia",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      height: 48,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, AppRoutes.configDay);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8),
                                                  child: const Icon(Icons.add)),
                                              const Text("Alocar dias"),
                                            ],
                                          )),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: taskController.tasks
                                      .getTasksInDay(weekController.activeDay)
                                      .length,
                                  itemBuilder: (context, index) => TaskCard(
                                    task: taskController.tasks.getTasksInDay(
                                        weekController.activeDay)[index],
                                  ),
                                ))
                ]);
              })));
    });
  }
}
