import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/widgets/dialogs/add_task_dialog.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PlanningWeekPage extends StatefulWidget {
  const PlanningWeekPage({super.key});

  @override
  State<PlanningWeekPage> createState() => _PlanningWeekPageState();
}

class _PlanningWeekPageState extends State<PlanningWeekPage> {
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(builder: (context, taskController, _) {
      taskController.tasks.sort((a, b) {
        if (a.day.isEmpty) return -1;
        if (b.day.isEmpty) return 1;
        return DateTime.parse(a.day).compareTo(DateTime.parse(b.day));
      });
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
          title: Text(
            "Tarefas da semana",
            style: TextStyle(color: AppColors.textNormal),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: ((context, index) => ListTile(
                        leading: taskController.tasks[index].isComplete
                            ? Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                              )
                            : Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                        title: Text(taskController.tasks[index].name),
                        trailing: taskController.tasks[index].day.isEmpty
                            ? null
                            : Chip(
                                label: Text(DateFormat.EEEE().format(
                                    DateTime.parse(
                                        taskController.tasks[index].day)))),
                      ))),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: _isBusy
                ? AppColors.secondary.withOpacity(0.2)
                : AppColors.secondary,
            onPressed: _isBusy
                ? null
                : () async {
                    String? value = await addTaskDialog(context);
                    if (value != null && value.isNotEmpty) {
                      setState(() => _isBusy = true);
                      taskController.store(value).then((value) {
                        setState(() => _isBusy = false);
                      }).catchError((err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackbar(content: Text(err.toString())));
                        setState(() => _isBusy = false);
                      });
                    }
                  },
            child: _isBusy
                ? CircularProgressIndicator(
                    color: AppColors.textLight,
                  )
                : const Icon(Icons.add)),
      );
    });
  }
}
