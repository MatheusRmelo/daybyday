import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/widgets/dialogs/add_task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlanningWeekPage extends StatefulWidget {
  const PlanningWeekPage({super.key});

  @override
  State<PlanningWeekPage> createState() => _PlanningWeekPageState();
}

class _PlanningWeekPageState extends State<PlanningWeekPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(builder: (context, taskController, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.dominant,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.textNormal,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const Text(
                "Tarefas da semana",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: ((context, index) => ListTile(
                        leading: taskController.tasks[index].isComplete
                            ? Icon(Icons.check_circle)
                            : Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                        title: Text(taskController.tasks[index].name),
                        trailing: taskController.tasks[index].day.isEmpty
                            ? Container()
                            : Chip(
                                label: Text(DateFormat.EEEE().format(
                                    DateTime.parse(
                                        taskController.tasks[index].day)))),
                      ))),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String? value = await addTaskDialog(context);
              if (value != null && value.isNotEmpty) {
                taskController.store(value);
              }
            },
            child: const Icon(Icons.add)),
      );
    });
  }
}
