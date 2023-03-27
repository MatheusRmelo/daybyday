import 'package:daybyday/models/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(task.isComplete ? Icons.check_circle : Icons.circle),
          Expanded(child: Text(task.name)),
        ],
      ),
    );
  }
}
