import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/widgets/circle_icon_button.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
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
              onPressed: () {},
            )
          ]),
      body: Expanded(
          child: TextField(
        decoration: InputDecoration(
          hintText: "Insert your message",
        ),
        scrollPadding: EdgeInsets.all(20.0),
        autofocus: true,
      )),
      floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: [Icon(Icons.add), Text("Adicionar")],
          ),
          onPressed: () {}),
    );
  }
}
