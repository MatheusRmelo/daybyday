import 'dart:io';

import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:daybyday/views/widgets/day_card.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:daybyday/views/widgets/task_card.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    var controller = context.read<WeekController>();
    if (controller.week == null) {
      _isLoading = true;
      controller.get(context).then((value) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }).catchError((err) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(ErrorSnackbar(content: Text(err.toString())));
          setState(() => _isLoading = false);
        }
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
          leadingWidth: 56,
          leading: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
            ),
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
          centerTitle: true,
          title: weekController.week != null
              ? Text(
                  "${DateFormat("d 'de' MMMM", 'pt_BR').format(weekController.week!.days.first)} até ${DateFormat("d 'de' MMMM", 'pt_br').format(weekController.week!.days.last)}",
                  style: TextStyle(fontSize: 16, color: AppColors.textNormal),
                )
              : const Text('Carregando...'),
          actions: [
            CircleIconButton(
                icon: Icons.date_range,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.selectWeek);
                }),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Consumer<TaskController>(builder: (context, taskController, _) {
              if (taskController.tasks.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Você ainda não planejou essa semana",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () {
                            taskController.task = null;
                            Navigator.pushNamed(context, AppRoutes.plannigWeek);
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
                                            const Text("Alocar tarefas"),
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
            })),
      );
    });
  }
}
