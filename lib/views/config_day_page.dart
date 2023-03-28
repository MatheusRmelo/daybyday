import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/drag_day.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/views/widgets/custom_dropdown_textfield.dart';
import 'package:daybyday/views/widgets/day_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfigDayPage extends StatefulWidget {
  const ConfigDayPage({super.key});

  @override
  State<ConfigDayPage> createState() => _ConfigDayPageState();
}

class _ConfigDayPageState extends State<ConfigDayPage> {
  DateTime activeDay = DateTime.now();
  Task? activeTask;

  @override
  void initState() {
    super.initState();
    var controller = context.read<WeekController>();
    var taskController = context.read<TaskController>();
    int index = controller.week!.days
        .indexWhere((element) => element.isSameDay(activeDay));
    if (index == -1) {
      activeDay = controller.week!.days.first;
    }
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
                Navigator.pushNamed(context, AppRoutes.addTask);
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
                                  setState(() => activeDay = day);
                                },
                                child: Chip(
                                    backgroundColor: day.isSameDay(activeDay)
                                        ? AppColors.highlight
                                        : null,
                                    label: Text(
                                      DateFormat.EEEE().format(day),
                                      style: TextStyle(
                                          color: day.isSameDay(activeDay)
                                              ? AppColors.textLight
                                              : AppColors.textNormal),
                                    )),
                              )))
                          .toList())),
              CustomDropdownTextField(
                  label: 'Tarefas não alocadas',
                  list: taskController.tasks.map((task) => task.name).toList(),
                  onChanged: ((value) {
                    if (value != null) {
                      int index = taskController.tasks
                          .indexWhere((element) => element.name == value);
                      if (index >= 0) {
                        setState(
                            () => activeTask = taskController.tasks[index]);
                      }
                    }
                  }),
                  value: activeTask == null
                      ? taskController.tasks.first.name
                      : activeTask!.name),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton(
                    child: const Text("Adicionar no dia"), onPressed: () {}),
              ),
              Text(
                "Tarefas da ${DateFormat.EEEE().format(activeDay)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 16),
                child: const Text(
                  "Ordene pela prioridade, as três primárias são mostradas sempre em cima.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]),
          );
        });
      }),
    );
  }
}
