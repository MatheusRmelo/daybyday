import 'package:daybyday/controllers/task_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void isPlanningBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      builder: (context) => Container(
            height: 260,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Column(children: [
              const Text("Qual o seu próximo passo?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                height: 48,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.plannigWeek);
                  },
                  child: const Text("Planejar a semana"),
                ),
              ),
              Container(
                height: 48,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 24),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<TaskController>().task = null;
                      Navigator.pushNamed(context, AppRoutes.formTask);
                    },
                    child: Text(
                      "Criar uma nova tarefa",
                      style: TextStyle(color: AppColors.secondary),
                    )),
              ),
            ]),
          ));
}
