import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/extensions/task_extension.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:daybyday/views/widgets/custom_dropdown_textfield.dart';
import 'package:daybyday/views/widgets/dialogs/delete_dialog.dart';
import 'package:daybyday/views/widgets/dialogs/is_planning_bottomsheet.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfigDayPage extends StatefulWidget {
  const ConfigDayPage({super.key});

  @override
  State<ConfigDayPage> createState() => _ConfigDayPageState();
}

class _ConfigDayPageState extends State<ConfigDayPage> {
  Task? activeTask;
  bool? _isSaving;
  bool _failedToSave = false;
  @override
  void initState() {
    super.initState();
    context
        .read<TaskController>()
        .initDay(week: context.read<WeekController>().week!);
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          TextButton(
              onPressed: () {
                isPlanningBottomSheet(context);
              },
              child: const Text(
                "Criar nova tarefa",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Consumer<WeekController>(builder: (context, weekController, _) {
        return Consumer<TaskController>(builder: (context, taskController, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                      children: weekController.week!.days
                          .map((day) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  taskController.activeDay = day;
                                },
                                child: Chip(
                                    backgroundColor:
                                        day.isSameDay(taskController.activeDay)
                                            ? AppColors.highlight
                                            : null,
                                    label: Text(
                                      DateFormat.EEEE('pt_br').format(day),
                                      style: TextStyle(
                                          color: day.isSameDay(
                                                  taskController.activeDay)
                                              ? AppColors.textLight
                                              : AppColors.textNormal),
                                    )),
                              )))
                          .toList())),
              if (taskController.tasks.notAlocatedTasks.isNotEmpty)
                CustomDropdownTextField(
                    label: 'Tarefas não alocadas',
                    list: taskController.tasks.notAlocatedTasks
                        .map((task) => task.name)
                        .toList(),
                    onChanged: ((value) {
                      if (value != null) {
                        int index = taskController.tasks.notAlocatedTasks
                            .indexWhere((element) => element.name == value);
                        if (index >= 0) {
                          setState(() => activeTask =
                              taskController.tasks.notAlocatedTasks[index]);
                        }
                      }
                    }),
                    value: activeTask == null
                        ? taskController.tasks.notAlocatedTasks.first.name
                        : activeTask!.name),
              if (taskController.tasks.notAlocatedTasks.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton(
                      child: const Text("Adicionar no dia"),
                      onPressed: () {
                        Task task = activeTask ??
                            taskController.tasks.notAlocatedTasks.first;
                        taskController
                            .update(task, day: taskController.activeDay)
                            .then((value) {
                          setState(() {
                            activeTask = taskController
                                    .tasks.notAlocatedTasks.isEmpty
                                ? null
                                : taskController.tasks.notAlocatedTasks.first;
                          });
                        });
                      }),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tarefas da ${DateFormat.EEEE('pt_br').format(taskController.activeDay)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (_isSaving != null)
                    _isSaving!
                        ? _failedToSave
                            ? const Text('Falha ao salvar')
                            : const Text("Salvando...")
                        : const Text("Salvo")
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 16),
                child: const Text(
                  "Ordene pela prioridade, as três primárias são mostradas sempre em cima.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        key:
                            Key("task_${taskController.activeTasks[index].id}"),
                        leading: Container(
                          width: 88,
                          child: Row(children: [
                            CircleIconButton(
                                margin: EdgeInsets.zero,
                                icon: Icons.edit,
                                onPressed: () {
                                  taskController.task =
                                      taskController.activeTasks[index];
                                  Navigator.pushNamed(
                                      context, AppRoutes.formTask);
                                }),
                            CircleIconButton(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                icon: Icons.delete,
                                onPressed: () {
                                  showDeleteDialog(context, "Ação crítica",
                                      "Excluir a tarefa ${taskController.activeTasks[index].name} é uma ação irreversível",
                                      () {
                                    taskController.destroy(
                                        taskController.activeTasks[index]);
                                  });
                                })
                          ]),
                        ),
                        title: Text(
                          taskController.activeTasks[index].name,
                          style: TextStyle(
                              decoration:
                                  taskController.activeTasks[index].isComplete
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                        ),
                        trailing: const Icon(Icons.menu),
                      );
                    },
                    itemCount: taskController.activeTasks.length,
                    onReorder: (int start, int current) {
                      // dragging from top to bottom
                      if (start < current) {
                        int end = current - 1;
                        Task startItem = taskController.activeTasks[start];
                        int i = 0;
                        int local = start;
                        do {
                          taskController.activeTasks[local] =
                              taskController.activeTasks[++local];
                          i++;
                        } while (i < end - start);
                        taskController.activeTasks[end] = startItem;
                      }
                      // dragging from bottom to top
                      else if (start > current) {
                        Task startItem = taskController.activeTasks[start];
                        for (int i = start; i > current; i--) {
                          taskController.activeTasks[i] =
                              taskController.activeTasks[i - 1];
                        }
                        taskController.activeTasks[current] = startItem;
                      }
                      setState(() {
                        _isSaving = true;
                        _failedToSave = false;
                      });
                      taskController.updatePriorities().then(((value) {
                        if (mounted) {
                          setState(() => _isSaving = false);
                        }
                      })).catchError((err) {
                        if (mounted) {
                          setState(() {
                            _isSaving = false;
                            _failedToSave = true;
                          });
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackbar(content: Text(err.toString())));
                      });
                    }),
              )
            ]),
          );
        });
      }),
    );
  }
}
