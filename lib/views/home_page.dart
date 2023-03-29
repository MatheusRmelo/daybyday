import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/day.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
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
  int _active = 0;

  @override
  void initState() {
    super.initState();
    context.read<WeekController>().get().then((value) {
      context.read<TaskController>().setCollection(value);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border)),
                  child: Icon(Icons.date_range,
                      color: AppColors.textNormal, size: 20),
                ),
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
                        "Você ainda não cadastrou tarefas essa semana",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.addTask);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: const Icon(Icons.add)),
                                const Text("Cadastrar tarefas"),
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
                            setState(() => _active = index);
                          },
                          isActive: index == _active,
                          date: weekController.week!.days[index]),
                    ),
                  ),
                  Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: taskController.tasks
                                  .getTasksInDay(
                                      weekController.week!.days[_active])
                                  .length,
                              itemBuilder: (context, index) => TaskCard(
                                task: taskController.tasks.getTasksInDay(
                                    weekController.week!.days[_active])[index],
                              ),
                            ))
                ]);
              })));
    });
  }
}
