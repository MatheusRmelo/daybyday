import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/views/widgets/dialogs/add_task_bottomsheet.dart';
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
        body: taskController.tasks.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Cadastre sua primeira atividade",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () async {
                            String? value = await addTaskBottomSheet(context);
                            if (value != null && value.isNotEmpty) {
                              setState(() => _isBusy = true);
                              taskController.store(value).then((value) {
                                setState(() => _isBusy = false);
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorSnackbar(
                                        content: Text(err.toString())));
                                setState(() => _isBusy = false);
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const Icon(Icons.add)),
                              const Text("Cadastrar tarefa"),
                            ],
                          )),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: taskController.tasks.length,
                        itemBuilder: ((context, index) => Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: AppColors.error,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.delete,
                                        color: AppColors.textLight),
                                    Text(
                                      "Excluir tarefa",
                                      style:
                                          TextStyle(color: AppColors.textLight),
                                    )
                                  ],
                                ),
                              ),
                              key: Key(
                                  "task_dismissible_${taskController.tasks[index].id}"),
                              onDismissed: (DismissDirection direction) {
                                taskController
                                    .destroy(taskController.tasks[index]);
                              },
                              child: ListTile(
                                leading: taskController.tasks[index].isComplete
                                    ? Icon(
                                        Icons.check_circle,
                                        color: AppColors.success,
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.border),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                title: Text(taskController.tasks[index].name),
                                trailing:
                                    taskController.tasks[index].day.isEmpty
                                        ? null
                                        : Chip(
                                            label: Text(DateFormat.EEEE('pt_br')
                                                .format(DateTime.parse(
                                                    taskController
                                                        .tasks[index].day)))),
                              ),
                            ))),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: _isBusy ? Colors.grey : AppColors.secondary,
            onPressed: _isBusy
                ? null
                : () async {
                    String? value = await addTaskBottomSheet(context);
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
