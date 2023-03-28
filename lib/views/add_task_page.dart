import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _date = DateTime.now();
  bool _isBusy = false;
  TextEditingController _textEditingController = TextEditingController();

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
                    hintText: 'Digite a tarefa'),
                scrollPadding: const EdgeInsets.all(20.0),
                autofocus: true,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Consumer<WeekController>(builder: (context, controller, snapshot) {
              return InkWell(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: _date,
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
                    "${_date.isToday ? 'Today' : DateFormat("EEEE").format(_date)}, ${DateFormat("d").format(_date)}",
                    style: TextStyle(
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
                    SizedBox(
                      width: 16,
                    ),
                    Text("Carregando...",
                        style: TextStyle(color: AppColors.textLight))
                  ]
                : const [Icon(Icons.add), Text("Adicionar")],
          ),
          onPressed: _isBusy
              ? null
              : () {
                  setState(() => _isBusy = true);
                  context
                      .read<TaskController>()
                      .store(_textEditingController.text)
                      .then((value) {
                    Navigator.pop(context);
                  }).catchError((err) {
                    setState(() => _isBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(err.toString()),
                      backgroundColor: AppColors.error,
                    ));
                  });
                }),
    );
  }
}
