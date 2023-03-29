import 'package:daybyday/utils/app_colors.dart';
import 'package:flutter/material.dart';

Future<String?> showDeleteDialog(BuildContext context, String title,
    String message, Function() onAction) async {
  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onAction();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child:
                  const Text("Excluir", style: TextStyle(color: Colors.white)))
        ],
      );
    },
  );
}
