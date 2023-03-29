import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/models/task.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task});
  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() => _isLoading = true);
          var taskController = context.read<TaskController>();
          taskController
              .update(widget.task, isComplete: !widget.task.isComplete)
              .then((value) {
            taskController.tasks.sort((a, b) => a.isComplete ? 1 : -1);
            setState(() => _isLoading = false);
          }).catchError((err) {
            setState((() => _isLoading = false));
            ScaffoldMessenger.of(context)
                .showSnackBar(ErrorSnackbar(content: Text(err.toString())));
          });
        },
        child: ListTile(
          leading: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.highlight,
                  ))
              : widget.task.isComplete
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
          title: Text(
            widget.task.name,
            style: TextStyle(
                decoration: widget.task.isComplete
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ));
  }
}
