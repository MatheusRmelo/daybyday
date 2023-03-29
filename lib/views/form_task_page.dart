import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/formats/date_format.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormTaskPage extends StatefulWidget {
  const FormTaskPage({super.key});

  @override
  State<FormTaskPage> createState() => _FormTaskPageState();
}

class _FormTaskPageState extends State<FormTaskPage> {
  DateTime? _date;
  bool _isBusy = false;
  bool _isEditing = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var controller = context.read<WeekController>();
    Task? task = context.read<TaskController>().task;
    _isEditing = task != null;
    if (task != null) {
      _textEditingController.text = task.name;
      _date = DateTime.parse(task.day);
    } else if (controller.week != null) {
      int index = controller.week!.days
          .indexWhere((element) => element.isSameDay(DateTime.now()));
      if (index == -1) {
        _date = controller.week!.days.first;
      } else {
        _date = DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: null,
          backgroundColor: AppColors.dominant,
          elevation: 0,
          actions: [
            CircleIconButton(
              icon: Icons.close,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Digite a tarefa',
                ).copyWith(focusedBorder: InputBorder.none),
                scrollPadding: const EdgeInsets.all(20.0),
                autofocus: true,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Consumer<WeekController>(builder: (context, controller, snapshot) {
              if (controller.week == null || _date == null) return Container();
              return InkWell(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: _date!,
                          firstDate: controller.week!.days.first,
                          lastDate: controller.week!.days.last)
                      .then((value) {
                    if (value != null) {
                      setState(() => _date = value);
                    }
                  });
                },
                child: Container(
                  width: 136,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.border)),
                  child: Text(
                    "${_date!.isToday ? 'Today' : DateFormat("EEEE").format(_date!)}, ${DateFormat("d").format(_date!)}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _isBusy
                ? [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text("Carregando...",
                        style: TextStyle(color: AppColors.textLight))
                  ]
                : [
                    Icon(_isEditing ? Icons.save : Icons.add),
                    Text(_isEditing ? "Editar" : "Adicionar")
                  ],
          ),
          onPressed: _isBusy
              ? null
              : () {
                  var taskController = context.read<TaskController>();
                  setState(() => _isBusy = true);
                  if (_isEditing) {
                    taskController
                        .update(taskController.task!,
                            day: _date, name: _textEditingController.text)
                        .then((value) {
                      Navigator.pop(context);
                    }).catchError((err) {
                      setState(() => _isBusy = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(err.toString()),
                        backgroundColor: AppColors.error,
                      ));
                    });
                  } else {
                    taskController
                        .store(_textEditingController.text, day: _date)
                        .then((value) {
                      Navigator.pop(context);
                    }).catchError((err) {
                      setState(() => _isBusy = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(err.toString()),
                        backgroundColor: AppColors.error,
                      ));
                    });
                  }
                }),
    );
  }
}
